module Mastermind
  
  class Game  #-----------------------------------------------------------------------
   class Validate
      def role?(entry)
        entry == "cm" || entry == "cb"
      end
    end    
  end
  
  class Code   #-----------------------------------------------------------------------
    class Validate
      attr_reader :code_size, :min_digit, :max_digit
      
      def initialize(code_size, min_digit, max_digit)
        @code_size = code_size
        @min_digit = min_digit
        @max_digit = max_digit
      end
      
      def is_numeric?(check_value)
        !!Float(check_value) rescue false
      end
    
      def entry?(check)
        if check.size == @code_size
          check.split("").all? {|digit| is_numeric?(digit) && digit.to_i>= @min_digit && digit.to_i <= @max_digit }
        else
          false
        end
      end
    
      def code_match?(check_value, code)
        check_value == code
      end  
    end
  end
      
  class Matches# ------------------------------------------------------------------
    class Validate 
      attr_reader :min_matches, :max_matches, :match_count
        
      def initialize(min_matches, max_matches)
        @min_matches = min_matches
        @max_matches = max_matches
        @match_count = match_count  
      end
        
      def is_numeric?(check_value)
        !!Float(check_value) rescue false
      end
      
      def match_count?(entry)
        if is_numeric?(entry)
          entry.to_i.between?(@min_matches, @max_matches) &&  (entry.to_i%2 == 0)
        else
          false
        end
      end
      
      def all_matches_played?(current_match, match_count)
        current_match == match_count
      end
    end
  end 
  
  class Player  #-----------------------------------------------------------------------
    class Validate
      attr_reader :guesses, :max_guesses
      
      def initialize(max_guesses)
        @guesses = guesses
        @max_guesses = max_guesses  
      end
      
      def entry?(check_value)
        !!Float(check_value) rescue false
      end
    
      def all_guesses_made?(guesses)
        guesses.size == @max_guesses
      end
    end
  end
  
end