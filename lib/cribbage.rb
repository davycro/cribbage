require "cribbage/version"
require "cribbage/console"
require 'awesome_print'

module Cribbage
  # Input:

  # H = heart S = spade D = diamond C = club

  # AH 5C 6D 7S 8C QD 9C

  class Card

    # Str format: 
    #  "5h" = five of hearts
    #  "AD" = ace of diamonds
    #  "10c" = ten of clubs

    attr_accessor :value
    attr_accessor :face_value
    attr_accessor :suit
    attr_accessor :card_str
    attr_accessor :index # index in a hand. Ie A = 0, 

    INDEX = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
    SUITS = {'H' => '♥', 'D' => '♦', 'C' => '♣', 'S' => '♠'}

    def initialize(str)
      raise "String cannot be blank!" if str.nil?
      raise "Must be a string!" unless str.is_a?(String)
      raise "Invalid length" if (str.size < 2 or str.size > 3)

      @value = self.compute_value(str.chop)
      @face_value = str.chop.upcase
      raise "Invalid face value" unless INDEX.include?(@face_value)
      @index = INDEX.index(@face_value)
      @suit  = str[-1].upcase
      @card_str = str
    end

    def to_s
      "[#{@face_value}#{SUITS[@suit]}]"
    end

     def compute_value(char)
       return 1 if char.upcase=='A'
       return 10 if %w(J Q K).include?(char.upcase)
       if char.to_i > 0 and char.to_i <= 10
         return char.to_i
       end
       raise "Could not compute value of #{char}"
     end
  end

  class Hand

    attr :points
    # key: fifteens
    # cards: [ [1,2], [3,4] ] MUST BE Nested array
    # points: 4

    attr :cards

    # Input is an array of strings from the command line
    # I.E. 4H JD QD KH 3H
    def initialize(cards_array)
      @cards = [ ]
      @points = { }
      cards_array.each { |c| @cards << Card.new(c) }

      find_fifteens
      find_runs
      find_pairs
      find_flush
      find_nobs
    end

    def starter_card
      @cards.first
    end

    def players_cards
      @cards[1...@cards.size]
    end 

    def total_score
      score = 0
      @points.each do |k,v|
        score += v[:point_value]
      end
      score
    end

    def print_score
      #  Your Hand
      #  5H | 6D 3D JH
      # 
      #  Total Points: +17
      #  Fifteens (+8): (5 5 5), (5 J), (5 J), (5 K)
      #  Runs:
      #  
      $stdout.printf "\n\n"
      $stdout.printf "%-3s %-21s %-10s\n\n", '', 'Hand:', starter_card.to_s + "" + players_cards.join('')

      print_points :fifteens
      print_points :runs
      print_points :pairs
      print_points :flush
      print_points :nobs

      $stdout.printf "\n%-3s %-10s %-10s\n", '', 'Total:', "+#{total_score}"

      $stdout.printf "\n\n"
    end
        #
    def print_points(key)
      if @points[key].nil?
        return false
      end
      cards = @points[key.to_sym][:cards] # should be array of array
      str = cards.map { |c| "" + c.join('') + "" }.join ", "
      title = key.to_s
      $stdout.printf "%-3s %-10s %-10s %-10s\n", '', title, "+#{@points[key][:point_value]}", str
    end

    def print_cards(label, cards)
      str = cards.map { |c| c.card_str }.join " "
      ap "#{label}: #{str}"
    end

    def find_fifteens
      found = nil
      [2,3,4,5].each do |combo_size|
        @cards.combination(combo_size).each do |card_combo|

          # Check for 15s
          card_count = 0
          card_combo.each { |card| card_count += card.value }
          if card_count == 15
            found ||= [ ]  
            found << card_combo
          end
        end
      end
      if found!=nil
        @points[:fifteens] = {cards: found, point_value: found.size*2}
      end
    end

    def find_runs
      found = { }
      [5,4,3].each do |combo_size|
        @cards.combination(combo_size).each do |combo|
          combo = combo.sort { |x,y| x.index <=> y.index } # sort by index
          next unless combo.map(&:face_value).uniq.size == combo.size # all cards must be unique
          if (combo.last.index - combo.first.index) == (combo.size-1)
            found[combo_size] ||= [ ]
            found[combo_size] << combo
          end
        end
      end
      if found.has_key?(5)
        @points[:runs] = {cards: found[5], point_value: 5}
        return true
      end
      if found.has_key?(4)
        cards = found[4]
        @points[:runs] = {cards: cards, point_value: cards.first.size*cards.size}
        return true
      end
      if found.has_key?(3)
        cards = found[3]
        @points[:runs] = {cards: cards, point_value: cards.first.size*cards.size}
        return found[3]
      end
      return nil
    end

    def find_pairs
      found = [ ]
      @cards.combination(2).each do |pair|
        if pair.first.face_value == pair.last.face_value
          found << pair
        end
      end
      if found.size==0
        return nil
      else
        @points[:pairs] = {cards: found, point_value: found.size*2}
      end
    end

    def find_flush
      hand = @cards
      if @cards.map(&:suit).uniq.size == 1
        @points[:flush] = {cards: [@cards], point_value: 5}
        return true
      end
      if players_cards.map(&:suit).uniq.size == 1
        @points[:flush] = {cards: [ players_cards ], point_value: 4}
        return true
      end
      return nil
    end

    def find_heels
      # Awarded when the starter card is a Jack
      if starter_card.face_value=='J'
        @points[:heels] = {cards: [[starter_card]], point_value: 2}
      end
    end

    def find_nobs
      # One for nobs
      jacks = players_cards.keep_if {|c| c.face_value=='J'}
      if jacks.map(&:suit).include?(starter_card.suit)
        @points[:nobs] = {cards: [ jacks.keep_if { |j| starter_card.suit==j.suit } ], point_value: 1}
      end
      return nil
    end

  end

end
