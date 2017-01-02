require 'thor'
require 'cribbage'
module Cribbage
  class CLI < Thor
    desc "count FLIP_CARD CARD_1 CARD_2 CARD_3 CARD_4", "count points in hand of five cards"
    def count(*cards)

      if cards.size != 5
        Console.error "You must input 5 cards"
        exit
      end

      hand = Cribbage::Hand.new(cards)
      hand.print_score
    end
  end
end