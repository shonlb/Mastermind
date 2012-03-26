module Mastermind
  class Player
    attr_accessor :role, 
      :guesses, 
      :score, 
      :wins, 
      :losses, 
      :guess_size,
      :min_digit,
      :max_digit
    
    def initialize(role)
      @role = role
      @guesses = []
      @score = 0
      @wins = 0
      @losses = 0
      @guess_size = 0
      @min_digit = 0
      @max_digit =0
    end
    
    MAX_GUESSES = 6
    
    def set_code_definitions(the_code_size, the_min_digit, the_max_digit)
      @code_size = the_code_size
      @min_digit = the_min_digit
      @max_digit = the_max_digit
    end

    def set_guess(guess, code)
      status = ""
      guess_digit = guess.split("")
      code_digit = code.split("")
      guess_digit.size.times do |x|
        status << ((guess_digit[x] == code_digit[x]) ? guess_digit[x] : "-")
      end
      
      @guesses << status
    end
    
    # -- Validators ---------------------------------------
    def is_numeric?(check_value)
      !!Float(check_value) rescue false
    end
    
    # -- AI Player ----------------------------------------
    def get_random_digit
      digit = rand(max_digit) + 1
      store = ((min_digit..max_digit) === digit) ? digit : store
    end  
    
    def make_first_guess
      store = ""
      guess_size.times do |digit|
        store << get_random_digit.to_s
      end
      store
    end
    
    def make_guess
      store = ""
      compare = guesses.last.split("")
      while store.size < guess_size
        check = compare[store.size]
        store << ((is_numeric?(check)) ? check.to_s : get_random_digit.to_s)
      end
      store
    end
     
    def generate_code
      
      store = ""
      while store.size < @guess_size
        store << get_random_digit.to_s
      end
      store
    end 
        
    def generate_guess
      store = (guesses == []) ? make_first_guess : make_guess
    end
    
  end
end