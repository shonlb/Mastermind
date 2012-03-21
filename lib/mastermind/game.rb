module Mastermind
  class Game
    attr_accessor :output, :display, :matches, :match_count, :human_player, :ai_player, :current_player
    
    def initialize(output)
      @output = output
      @display = Display.new
      @matches = Matches.new
    end
    
    def set_match_count(value)
      if validate("match_count", value)
        @match_count = value.to_i
      else
        show_match_prompt
        get_match_count(input)
      end
    end
    
    def create_human_player(role)
      if validate("role", role)
        set = (role == "cm") ? "Code Maker" : "Code Breaker"
        @human_player = Player.new(set)
      else
        show_role_prompt
        get_role
      end  
    end
    
    def create_ai_player(role)
      set = (role == "cm") ? "Code Breaker" : "Code Maker"
      @ai_player = Player.new(set)
    end
    
    def set_current_player
      @current_player = (@human_player.role == "Code Maker") ? @ai_player : @human_player 
    end
    
    #--Validators-------------------------------------
    def is_numeric?(check_value)
        !!Float(check_value) rescue false
    end
    
    def validate(type, what)
      case type
      when "match_count"
        is_numeric?(what) && what.to_i.between?(@matches.min_matches,@matches.max_matches) && what.to_i%2 == 0
      when "role"
        what == "cm" || what == "cb"
      else
        false
      end
    end
    
    #--Display----------------------------------------       
    def show_welcome
      @output.puts display.message("welcome", "", "")
    end

    def show_rules
      @output.puts display.message("rules", "", "")
    end
    
    def show_match_prompt
      @output.puts display.message("match_prompt", @matches.min_matches, @matches.max_matches)
    end
    
    def show_role_prompt
      @output.puts display.message("role_prompt", "", "")
    end
    
    def show_role_confirmation
      @output 
    end
    
    #--User Input-------------------------------------
    def get_match_count(input)
      (input == nil) ? gets.chomp : input
    end
    
    def get_role(input)
      (input == nil) ? gets.chomp : input
    end
    
    #--Game Progression
    def setup(matches, role)
      show_welcome
      show_rules
      show_match_prompt
      set_match_count(get_match_count(matches))
      show_role_prompt
      create_human_player(get_role(role))
      create_ai_player(@human_player.role)
      set_current_player
      show_role_confirmations(@human_player.role)
    end
  end
end