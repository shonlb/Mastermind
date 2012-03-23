module Mastermind
  class Game
    attr_accessor :output, :display, :matches, :human_player, :ai_player, :current_player, :code
    
    def initialize(output, input)
      @output = output
      @input = input
      @display = Display.new(output)
      @matches = Matches.new
      @code = Code.new
      @current_player = nil
    end
    
    def create_human_player(role)
      if valid_role?(role)
        set = (role == "cm") ? "Code Maker" : "Code Breaker"
        @human_player = Player.new(set)
        @human_player.guess_size = code.code_size
        @human_player.min_digit = code.min_digit
        @human_player.max_digit = code.max_digit
      else
        show_role_prompt
        user_input
      end  
    end
    
    def create_ai_player
      set = (human_player.role == "Code Maker") ? "Code Breaker" : "Code Maker"
      @ai_player = Player.new(set)
      @ai_player.guess_size = code.code_size
      @ai_player.min_digit = code.min_digit
      @ai_player.max_digit = code.max_digit
    end
    
    def set_current_player
      if current_player == nil
        current_player = (human_player.role == "Code Maker") ? ai_player : human_player
      else
        current_player = (current_player == ai_player) ? human_player : ai_player
      end   
    end

    def set_code(value)
      code.code = value
    end

    def set_match_count(value)
      if matches.is_valid?(value)
        matches.match_count = value.to_i
      else
        show_match_prompt
        user_input
      end
    end
    
    def update_current_match
      match.current_match += 1  
    end

    def human_win
      (human_player.role == "Code Maker") ? human_player.score += 1 : human_player.score
      human_player.wins += 1
      ai_player.losses += 1
    end

    def ai_win
      (ai_player.role == "Code Maker") ? ai_player.score += 1 : ai_player.score
      ai_player.wins += 1
      human_player.losses += 1      
    end
    
    def update_player_stats
      if code_match?(current_player.guesses.last)
        (current_player == ai_player) ? ai_win : human_win
      else
        (current_player == ai_player) ? human_win : ai_win
      end
    end 
    
    def update_match
      matches.match_count += 1
    end
    
    def update_game_stats
      update_player_stats
      update_match
    end
       
    #--Validators----------------------------------
    def valid_role?(entry)
      entry == "cm" || entry == "cb"
    end
    
    def code_match?(check_value)
      !!Float(check_value) rescue false
    end
    
    #--Player Input-------------------------------------
    def user_input
      input = gets.chomp 
    end
    
    def get_match_code
      if current_player == ai_player
        current_player.generate_code
      else
        display.message("code_prompt", code.code_size, "code")
        user_input
      end
    end
    
    #--Display---------------------------------------------
    def match_end_alert
      if current_player.guesses === code.code
        (current_player == ai_player) ? display.message("lose", "", "") : display.message("win", "", "")
      else
        (current_player == ai_player) ? display.message("win", "", "") : display.message("lose", "", "")
      end
    end
    
    def game_over
      
    end
    
    #--Game Progression------------------------------------
    def launch_setup
      if match.current_match ==0
        display.message("welcome", "", "")
        display.message("rules", "", "")
        display.message("match_prompt", matches.min_matches, matches.max_matches)
        set_match_count(user_input)
        display.message("role_prompt", "", "")
        create_human_player(user_input)
        create_ai_player(@human_player.role)
      end
      update_current_match
      set_current_player
      display.message("confirm_role", human_player.role, "")
    end
    
    def launch_code_maker
      matches.set_current
      current_player.set_code_definitions(code.code_size, code.min_digit, code.max_digit)
      display.message("current_match", matches.current_match, matches.match_count)
      set_code(get_match_code)
    end
    
    def ai_guesses
      while current_player.guesses.size < current_player.max_guesses
        current_player.set_guess(current_player.generate_guess, code.code)
        if code_match?(current_player.guesses.last)
          break #ai has broken the code
        end
      end
    end
    
    def code_breaker_ai
      display.code_grid(code.code)
      ai_guesses
      display.guesses(current_player.guesses)
      match_end_alert
      update_game_stats
      advance_game
    end
    
    def code_breaker_human
        display.message("code_prompt", code.code_size, "code")
        #get the guess
        #validate the guess
        #save the guess
        #display the guess
        #check for match
        #continue guessing
        #match_end_alert
        #update_game_stats
        #advance_game
        
    end
    
    def launch_code_breaker
      (current_player == ai_player) ? code_breaker_ai : code_breaker_human  
    end
    
    def advance_game
      if match.current_match < match.match_count
        game_play
      else
        game_over
      end
    end
    
    def game_play
      launch_setup 
      launch_code_maker
      launch_code_breaker
    end
  end
end