module Mastermind
  class Game
    attr_accessor :output, :display, :matches, :human_player, :ai_player, :code_breaker, :code_maker, :code
    
    def initialize(output, input)
      @output = output
      @input = input
      @display = Display.new(output)
      @matches = Matches.new
      @code = Code.new
      @code_breaker = nil
      @code_maker = nil
    end
    
    def create_human_player(role)
      if valid_role?(role)
        set = (role == "cm") ? "Code Maker" : "Code Breaker"
        @human_player = Player.new(set)
      else
        display.message("role_prompt", "", "")
        create_human_player(user_input)
      end  
    end
    
    def create_ai_player
      set = (human_player.role == "Code Maker") ? "Code Breaker" : "Code Maker"
      @ai_player = Player.new(set)
    end
    
    def set_current_players 
      new_code_maker = ""
      new_code_breaker = ""     
      if code_breaker == nil
        new_code_breaker = (human_player.role == "Code Maker") ? ai_player : human_player
        new_code_maker = (human_player.role == "Code Maker") ? human_player : ai_player
      else
        new_code_breaker = (code_breaker == human_player) ? ai_player : human_player
        new_code_maker = (code_maker == human_player) ? ai_player : human_player
      end
      
      @code_breaker = new_code_breaker
      @code_maker = new_code_maker
      code_breaker.role = "Code Breaker"
      code_maker.role = "Code Maker"
    end

    def set_code(value)
      code.code = value
    end

    def set_match_count(value)
      if matches.is_valid?(value)
        matches.match_count = value.to_i
      else
        display.message("match_prompt", matches.min_matches, matches.max_matches)
        set_match_count(user_input)
      end
    end
    
    def update_current_match
      matches.current_match += 1  
    end

    def code_breaker_win
      code_breaker.wins += 1
      code_maker.losses += 1
    end

    def code_maker_win
      code_maker.wins += 1
      code_maker.score += 1
      code_breaker.losses += 1
    end
    
    def update_player_stats
      if code_match?(code_breaker.guesses.last)
        code_breaker_win
      else
        code_maker_win
      end
    end  
    
    def update_match
      matches.match_count += 1
    end
    
    
       
    #--Validators----------------------------------
    def valid_role?(entry)
      entry == "cm" || entry == "cb"
    end
    
    def valid_code?(entry)
      code.is_valid?(entry)
    end
    
    def code_match?(check_value)
      check_value == code.code
    end
    
    def all_matches_played?
      matches.current_match == matches.match_count
    end
    
    #--Player Input-------------------------------------
    def user_input
      @input = gets.chomp 
    end
    
    def get_match_code
      if code_maker == human_player
        display.message("code_prompt", code.code_size, "code")
        check = user_input
        (valid_code?(check)) ? check : get_match_code
      else
        code_maker.generate_code
      end
    end
    
    def get_human_guess
      display.message("code_prompt", code.code_size, "code")
      guess = user_input
    end    
    
    #--Display---------------------------------------------
    def match_end_alert
      if code_match?(code_breaker.guesses.last)
        (code_breaker == ai_player) ? display.message("lose", "", "") : display.message("win", "", "")
      else code_breaker.all_guesses_made?
        (code_breaker == ai_player) ? display.message("win", "", "") : display.message("lose", "", "")
      end
    end
    
    def display_game_stats
      display.stats("You", human_player.wins, human_player.losses, human_player.score)
      display.stats("AI", ai_player.wins, ai_player.losses, ai_player.score)
      display.game_stats(matches.current_match, matches.match_count)
    end
    
    def game_over
      display.message("game_over", "", "")
    end
    
    #--Game Progression------------------------------------
    def launch_setup
      if matches.current_match == 0
        display.message("welcome", "", "")
        display.message("rules", "", "")
        display.message("match_prompt", matches.min_matches, matches.max_matches)
        set_match_count(user_input)
        display.message("role_prompt", "", "")
        
        create_human_player(user_input)
        create_ai_player
      end
      update_current_match
      set_current_players
      display.message("confirm_role", human_player.role, "")
    end
    
    def launch_code_maker
      code_breaker.set_code_definitions(code.code_size, code.min_digit, code.max_digit)
      display.message("current_match", matches.current_match, matches.match_count)
      set_code(get_match_code)
    end
    
    def code_breaker_ai
      display.code_grid(code.code)
      code_breaker.exhaust_guesses(code.code)
      display.guesses(code_breaker.guesses)
      match_end_alert
      update_player_stats
      display_game_stats
      advance_game
    end
    
    def code_breaker_human
      display.message("code_set", "", "")
      #if code_breaker.all_guesses_made?
      
      
      while code_breaker.guesses.size < code_breaker.max_guesses
        guess = get_human_guess
        if code.is_valid?(guess)
          code_breaker.set_guess(guess, code.code)
          display.guesses(code_breaker.guesses)
          if code_match?(code_breaker.guesses.last)
            break
          else
            guess = get_human_guess
          end
        else
          guess = get_human_guess
        end
      end
        
      match_end_alert
      update_game_stats
      advance_game        
    end
    
    def launch_code_breaker
      (code_breaker == ai_player) ? code_breaker_ai : code_breaker_human  
    end
    
    def advance_game
      (all_matches_played?) ? game_over : game_play
    end
    
    def game_play
      launch_setup 
      launch_code_maker
      launch_code_breaker
    end
  end
  
end