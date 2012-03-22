module Mastermind
  class Game
    attr_accessor :output, :display, :matches, :human_player, :ai_player, :current_player, :code
    
    def initialize(output, input)
      @output = output
      @input = input
      @display = Display.new(output)
      @matches = Matches.new
      @code = Code.new
    end
    
    def create_human_player(role)
      if valid_role?(role)
        set = (role == "cm") ? "Code Maker" : "Code Breaker"
        @human_player = Player.new(set)
      else
        show_role_prompt
        user_input
      end  
    end
    
    def create_ai_player(role)
      set = (role == "cm") ? "Code Breaker" : "Code Maker"
      @ai_player = Player.new(set)
    end
    
    def set_current_player
      @current_player = (human_player.role == "Code Maker") ? ai_player : human_player 
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
    #--Validators----------------------------------
    def valid_role?(entry)
      entry == "cm" || entry == "cb"
    end
    
    #--Player Input-------------------------------------
    def user_input
      input = gets.chomp 
    end
    
    def get_match_code
      if current_player == ai_player
        code.generate
      else
        display.message("code_prompt", "", "")
        user_input
      end
    end
    
    #--Game Progression---------------------
    def launch_setup
      display.message("welcome", "", "")
      display.message("rules", "", "")
      display.message("match_prompt", matches.min_matches, matches.max_matches)
      set_match_count(user_input)
      display.message("role_prompt", "", "")
      create_human_player(user_input)
      create_ai_player(@human_player.role)
      set_current_player
      display.message("confirm_role", human_player.role, "")
    end
    
    def launch_code_maker
      matches.set_current
      display.message("current_match", matches.current_match, matches.match_count)
      set_code(get_match_code)
    end
    
    def code_breaker
      display.code_grid()
    end
    
    def game_play
      launch_setup
      launch_code_maker
      launch_code_breaker
    end
  end
end