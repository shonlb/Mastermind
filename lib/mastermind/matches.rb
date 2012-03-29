module Mastermind
  class Matches
    attr_accessor :match_count, :current_match, :code
    attr_reader :min_matches, :max_matches, :valid

    def initialize
      @min_matches = 6
      @max_matches = 20
      @match_count = 0
      @current_match = 0
      @code = ""
      @valid = Validate.new(@min_matches, @max_matches)
    end
    
    def set_current
      @current_match += 1
    end   
  end
end