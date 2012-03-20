module Mastermind
  class Launch # ----------------------------------------------------------
    attr_accessor :input, :output, :ai_player, :human_player, :match_count, :code, :total_matches
    def initialize(output)
      @input = nil
      @output = output
      @display = Display.new
      @total_matches = 0
    end
    
    MIN_GAMES = 6
    MAX_GAMES = 20
    GUESS_SIZE = 4
    MIN_GUESS_DIGIT = 1
    MAX_GUESS_DIGIT = 6
    MAX_GUESSES = 6
    GUESS_RANGE = "(#{MIN_GUESS_DIGIT} .. #{MAX_GUESS_DIGIT})"
    
    def create_ai_player(role)
      @ai_player = Player.new(role)
    end
    
    def set_matches(number)
      @match_count = number
    end

    def set_roles(role)
      ai_role = (role == "cm") ? "Code Breaker" : "Code Maker"
      human_role = (role == "cm") ? "Code Maker" : "Code Breaker"
      @human_player = Player.new(human_role)
      @ai_player = Player.new(ai_role)  
    end
    
    def set_current_player
      @current_player = (@human_player.role == "Code Maker") ? @human_player : @ai_player
    end
    
    def set_code(code)
      @code = code
    end
    
    def set_ai_guess(guess)
      @ai_player.guesses << guess
    end    
    
    #--Validators----------------------------------------------------------
    def is_numeric?(check_value)
      !!Float(check_value) rescue false
    end
    
    def valid_match_count?(check_value)
      (check_value.all? {|check| isnumeric?(check) && check >= MIN_MATCHES && check <= MAX_MATCHES}) ? true : false
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
    
    def validate_code(code)
      (valid_code?(code)) ? set_code(code) : show_code_prompt
    end

    #--Display-------------------------------------------------------------
    def show_welcome
      @output.puts @display.message("welcome", "", "")
    end
    
    def show_rules
      @output.puts @display.message("rules", "", "")
    end
    
    def show_match_prompt
      @output.puts @display.message("game_prompt", MIN_MATCHES, MAX_MATCHES)
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
      while @ai_player.guesses.size < MAX_GUESSES 
        generate_code("guess")
        if has_match?(@ai_player.guesses.last)
          break
          @ai_player.wins += 1
          @human_player.losses += 1
          @total_matches += 1
          show_loser
          (@total_matches < @match_count) ? launch_code_maker_ai : show_game_winner
        end
      end 
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
  
  class Display #------------------------------------------------------------
    def message(selection, exp1, exp2)
      show ={
        "welcome"               =>  "Welcome to Mastermind!",
        "rules"                 =>  "Here's how to play...",
        "set_matches"           =>  "Enter matches to be played (#{exp1}..#{exp2}).",
        "match_confirm"         =>  "Game consists of #{exp1} matches.",
        "match_display"         =>  "Match #{exp1} of #{exp2}",
        "get_role"              =>  "Who will be? Enter \"cm\" for Code Maker or \"cb\" for Code Breaker",
        "confirm_role"          =>  "You are the #{exp1}",
        "guess_prompt"          =>  "Enter the code.",
        "code_maker_instruct"   =>  "These are instructions for making a code.",
        "code_breaker_instruct" =>  "These are instructions for breaking a code.",
        "code_prompt"           =>  "Enter your #{exp1}-digit code:",
        "guess_limit"           =>  "You are out of guesses.",
        "win"                   =>  "You've won the match!",
        "lose"                  =>  "I'm #1 -- You've lost the match!"
      }
      show[selection]
    end
  end # end Display class
  
  class Player #------------------------------------------------------------
    attr_accessor :role, :guesses, :wins, :losses
    def initialize(role)
      @role = role
      @guesses = []
      @wins = 0
      @losses = 0
    end
  end # end Player class
  

end # end Mastermind module