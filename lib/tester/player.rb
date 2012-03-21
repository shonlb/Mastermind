module Mastermind
  class Player #------------------------------------------------------------
    attr_accessor :role, :guesses, :wins, :losses, :code
    def initialize(role)
      @role = role
      @guesses = []
      @wins = 0
      @losses = 0
    end   
    
    GUESS_SIZE = 4
    MIN_GUESS_DIGIT = 1
    MAX_GUESS_DIGIT = 6
    MAX_GUESSES = 6
    GUESS_RANGE = (MIN_GUESS_DIGIT .. MAX_GUESS_DIGIT)

    def set_code(code)
      @code = code
    end
    
    def set_guess(guess)
      @guesses << guess
    end 
    
    def update_role(new_role)
      @role = new_role
    end

    #--Validators----------------------------------------------------------
    def is_numeric?(check_value)
      !!Float(check_value) rescue false
    end
    
    def valid_match_count?(check_value)
      check_value.all? {|check| isnumeric?(check) && check >= MIN_MATCHES && check <= MAX_MATCHES && check%2 == 0}
    end

    def validate_matches(number)
      (valid_match_count?(number)) ? set_matches(number.to_i) : game_prompt
    end    
    
    def validate_role(role)
      (role == "cm" || role == "cb") ? set_role : show_role_prompt
    end
    
    def valid_code?(code)
      if is_numeric?(code)
         code.split("").all? do |check|
          valid_digit?(check.to_i)
        end
      else
        false
      end      
    end
    
    def valid_digit?(digit)
      digit.between?(MIN_GUESS_DIGIT, MAX_GUESS_DIGIT)
    end
    
    #def has_match?(entry)
    #  (code == )
    #end

    #--User Input---------------------------------------------------------
    def get_match_count(number)
      input = (number == nil) ? gets.chomp : number
      validate_matches(input)
    end
    
    def get_role(role)
      input = (role == nil) ? gets.chomp : role 
      validate_role(input)
    end
    
    def get_code(code)
      input = (code == nil) ? gets.chomp : code
      validate_code(input)
    end
    
    #--AI Input-----------------------------------------------------------
    def generate_code(type)
      code = ""
      size = GUESS_SIZE
      size.times do |x|
        digit = rand(MAX_GUESS_DIGIT) + 1
        code << ((digit < MIN_GUESS_DIGIT) ? MIN_GUESS_DIGIT : digit).to_s
      end
      (type == "code") ? set_ai_guess(code) : set_guess(code)  
    end
    
    def ai_guesses
      while guesses.size < MAX_GUESSES 
        generate_code("guess")
        if has_match?(@ai_player.guesses.last)
          break
          update_stats
        end
      end 
    end 
    
  end # end Player class  
end # end Mastermind module