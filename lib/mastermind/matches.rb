module Mastermind
  class Matches
    attr_reader :min_matches, :max_matches
    def initialize
      @min_matches = 6
      @max_matches = 20
    end
  end
end