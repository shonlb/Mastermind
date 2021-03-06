module Mastermind
  class Player
    attr_accessor :guesses, 
      :score, 
      :wins, 
      :losses,
      :points, 
      :guess_size,
      :min_digit,
      :max_digit
      :valid
      
    attr_reader :max_guesses, :valid, :code_size, :min_digit, :max_digit
    
    def initialize(code_size, min_digit, max_digit)
      @guesses = []
      @score = 0
      @wins = 0
      @losses = 0
      @points = 0
      @guess_size = code_size
      @min_digit = min_digit
      @max_digit = max_digit
      @max_guesses = 6
      @valid = Validate.new(@max_guesses)
    end

    def set_guess(guess, code)
      status = ""
      guess_digit = guess.split("")
      code_digit = code.split("")
      guess_digit.size.times do |x|
        status << ((guess_digit[x] == code_digit[x]) ? guess_digit[x] : "x")
      end
      
      @guesses << status
    end
    
    # -- Score Keeping ------------------------------------
    def update_score(w, l, p)
      @wins = @wins + w
      @losses = @losses + l
      @points = @points + p
    end
    
    # -- AI Player ----------------------------------------
    def get_random_digit
      digit = rand(@max_digit) + 1
      ((@min_digit..@max_digit) === digit) ? digit : get_random_digit
    end  
    
    def make_first_guess
      (@min_digit..@guess_size).map { rand(@max_digit) + 1 }.join
    end
    
    def make_guess
      store = ""
      compare = @guesses.last.split("")
      while store.size < @guess_size
        check = compare[store.size]
        store << ((@valid.entry?(check)) ? check.to_s : get_random_digit.to_s)
      end
      store
    end
     
    def generate_code
      (@min_digit..@guess_size).map { rand(@max_digit) + 1 }.join
    end   
        
    def generate_guess
      store = (@guesses == []) ? make_first_guess : make_guess
    end
    
    def exhaust_guesses(code)
      while @guesses.size < @max_guesses
        set_guess(generate_guess, code)
        if @valid.entry?(@guesses.last)
          break
        end
      end 
    end
    
  end
end