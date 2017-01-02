require 'thor'
require 'cribbage'
module Cribbage
  class CLI < Thor
    desc "count START CARD_1 CARD_2 CARD_3 CARD_4", "count points in hand of five cards"
    def count(*cards)

      hand = Cribbage::Hand.new(cards)
      hand.print_score
    end
  end
end