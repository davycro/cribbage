require 'cribbage'
module Cribbage

  class Console

    def self.error(msg)
      msg = "\e[31m#{msg}\e[0m"
      $stdout.printf "\n%-3s %-10s\n\n", '', msg
    end

  end

end