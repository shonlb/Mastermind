module Mastermind
  class Matches
    attr_accessor :match_count, :current_match, :code
    attr_reader :min_matches, :max_matches

    def initialize
      @min_matches = 6
      @max_matches = 20
      @match_count = 0
      @current_match = 0
      @code = ""
    end
    
    def set_current
      @current_match += 1
    end
    
    #--Validators---------------------------------------
    def is_numeric?(check_value)
      !!Float(check_value) rescue false
    end
    
    def is_valid?(entry)
      check = [] 
      if is_numeric?(entry)
        check << entry.to_i.between?(@min_matches, @max_matches)
        check << (entry.to_i%2 == 0)
      else
        check << false
      end
      
      check.all? { |x| x == true }
     end
  end
end