module Mastermind
  class Game # ----------------------------------------------------------
    attr_accessor :input, :output, :ai_player, :human_player, :match_count, :total_matches
    def initialize(output)
      @input = nil
      @output = output
      @display = Display.new
      @total_matches = 0
    end
    
    def create_ai_player(role)
      set = (role == "cm") ? "Code Breaker" : "Code Maker"
      @ai_player = Player.new(set)
    end
    
    def create_human_player(role)
      set = (role == "cm") ? "Code Maker" : "Code Breaker"
      @human_player = Player.new(set)
    end
    
    def set_matches(number)
      @match_count = number
    end
    
    def set_current_player
      @current_player = (@human_player.role == "Code Maker") ? @human_player : @ai_player
    end
    
    #--Display-------------------------------------------------------------
    def show_welcome
      @output.puts display.message("welcome", "", "")
    end
    
    def show_rules
      @output.puts display.message("rules", "", "")
    end
    
    def show_match_prompt
      @output.puts display.message("game_prompt", MIN_MATCHES, MAX_MATCHES)
    end
    
    def show_match_confirm
      @output.puts display.message("game_prompt", @match_count)
    end
    
    def show_role_prompt
      @output.puts display.messages("role_prompt")
    end
    
    def show_role_confirmation  
      @output.puts display.messages("role_confirm", @human_player["role"])
    end

    def show_current_match
      @output.puts display.messages("current_game", @current_match, @match_count)
    end
    
    def show_code_prompt
      @output.puts display.messages("code_prompt", GUESS_SIZE, GUESS_RANGE)
    end
    
    def show_loser
      @output.puts display.message("lose", "", "")
    end
    
    def show_game_winner
      
    end
    
    #--Validators---------------------------------------------------------
    def validate_code(entry)
      (valid_code?(entry)) ? set_code(entry) : show_code_prompt
    end
            
    #--Game Progression---------------------------------------------------
    def setup(matches, role)
      show_welcome
      show_rules
      show_game_prompt
      get_match_count(matches)
      show_role_prompt
      get_role(role)
      set_current_player
      show_current_match
      show_role_confirmation      
      (@human_player.role == "Code Maker") ? launch_code_maker_human : launch_code_maker_ai
    end
    
    def launch_code_maker_human
      show_code_prompt
      get_code
      ai_guesses
    end    
    
  end #end Launch class
end # end Mastermind module