module Mastermind
  class Game
    #--Initialize and set values-----------------------------------------------------------------
    attr_reader :display, :matches, :human_player, :ai_player, :code_breaker, :code_maker, :code, :valid

    def initialize(output, input)
      @input = input
      @display = Display.new(output)
      @matches = Matches.new
      @code = Code.new
      @human_player = Player.new(@code.code_size, @code.min_digit, @code.max_digit)
      @ai_player = Player.new(@code.code_size, @code.min_digit, @code.max_digit)
      @valid = Validate.new
    end
   
    def set_current_players 
      if @code_maker.nil?
        role_select = user_input
        if @valid.role?(role_select)
          @code_maker = (role_select == "cm") ? @human_player : @ai_player
          @code_breaker = (role_select == "cb") ? @human_player : @ai_player
        else
          set_current_players  
        end
      else
        @code_maker = (@code_maker == @human_player) ? @ai_player : @human_player
        @code_breaker = (@code_breaker == @human_player) ? @ai_player : @human_player
      end
      @code_breaker.guesses = []
    end

    def set_code(value)
      @code.code = value
    end

    def set_match_count(value)
      if @matches.valid.match_count?(value)
        @matches.match_count = value.to_i
      else
        @display.message("match_prompt", @matches.min_matches, @matches.max_matches)
        set_match_count(user_input)
      end
    end
    
    def update_current_match
      @matches.current_match += 1  
    end
    
    def update_player_stats
      if @code.valid.code_match?(@code_breaker.guesses.last, @code.code)
        @code_breaker.update_score(1, 0, 0)
        @code_maker.update_score(0, 1, 0)
      else
        @code_breaker.update_score(0, 1, 0)
        @code_maker.update_score(1, 0, 1)
      end
    end      
    
    #--Player Input-------------------------------------
    def user_input
      @input.gets.chomp 
    end
    
    def get_match_code      
      if @code_maker == @human_player
        @display.message("code_prompt", @code.code_size, "code using digits between #{@code.min_digit} and #{@code.max_digit}")
        check = user_input
        (@code.valid.entry?(check)) ? check : get_match_code
      else
        @code_maker.generate_code
      end
    end
    
    def get_human_guess
      @display.message("guess_prompt", @code.code_size, "guess using digits between #{@code.min_digit} and #{@code.max_digit}")
      guess = user_input
    end    
    
    #--Display---------------------------------------------
    def role_confirmation
      role = (@code_maker == @human_player) ? "Code Maker" : "Code Breaker"
      @display.message("confirm_role", role, "")
    end
    
    def match_end_alert
      if @code.valid.code_match?(@code_breaker.guesses.last, @code.code)
        (@code_breaker == @ai_player) ? @display.message("lose") : @display.message("win")
      else 
        if @code_breaker == @ai_player
          @display.message("win")
        else
          @display.message("lose")
          @display.code_grid(@code.code)
        end
      end
    end
    
    def display_game_stats
      @display.stats("You", @human_player.wins, @human_player.losses, @human_player.points)
      @display.stats("AI", @ai_player.wins, @ai_player.losses, @ai_player.points)
      @display.game_stats(@matches.current_match, @matches.match_count)
    end
    
    #--Game Progression------------------------------------
    def launch_setup
      if @matches.current_match == 0
        @display.message("welcome")
        @display.message("rules")
        @display.message("match_prompt", matches.min_matches, matches.max_matches)
        set_match_count(user_input)
        @display.message("role_prompt")
      end
      update_current_match
      set_current_players 
      role_confirmation
    end
    
    def launch_code_maker
      @display.message("current_match", @matches.current_match, @matches.match_count)
      set_code(get_match_code)
    end
    
    def launch_code_breaker
      (@code_breaker == @ai_player) ? code_breaker_ai : code_breaker_human  
    end
        
    def code_breaker_ai
      @display.code_grid(@code.code)
      @code_breaker.exhaust_guesses(@code.code)
      @display.guesses(@code_breaker.guesses)
      match_end_alert
      update_player_stats
      display_game_stats
      advance_game unless @matches.match_count == @matches.current_match
    end
    
    def code_breaker_human
      puts "code_breaker_human called"
      (@code_breaker.guesses.size == 0) ? @display.message("code_set") : @display.message("try_again")
      
      while @code_breaker.valid.all_guesses_made?(@code_breaker.guesses) == false
      #until @code_breaker.valid.all_guesses_made?(@code_breaker.guesses)
        guess = get_human_guess
        
        if @code.valid.entry?(guess)
          @code_breaker.set_guess(guess, @code.code)
          @display.last_guess(@code_breaker.guesses.last, @code_breaker.guesses.size)
          if @code.valid.code_match?(guess, @code.code)
            break
          end 
        end
      end
      
      match_end_alert
      update_player_stats
      display_game_stats
      advance_game unless @matches.match_count == @matches.current_match
    end
    
    def advance_game 
        game_play
    end
    
    def game_play
      launch_setup 
      launch_code_maker
      launch_code_breaker
    end
  end # class Game
end # module Mastermind