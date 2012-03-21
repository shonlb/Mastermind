module Mastermind
  
  class Player(role)
   attr_accessor :role, :guesses, :wins, :losses
    def initialize
      @role = role
      @guesses = []
      @wins = 0
      @losses = 0
    end  
  end
  
  class Game

    #--Helpers----------------------------------------------------------------

    def is_numeric?(check_value)
        !!Float(check_value) rescue false
    end

    #--Variables--------------------------------------------------------------

    CODE_SIZE = 4
    FLOOR_DIGIT = 1
    CEILING_DIGIT = 6
    MIN_GAMES = 6
    MAX_GAMES = 20
    ALLOWED_GUESSES = 6

    def initialize
      @games_played = 0
    end

    def i_am_player(role)
      @i_am_player = Player(role).new
    end
    
    def ai_player(role)
      @ai_player = Player(role).new
    end

    def set_code(code)
      @set_code = code
    end

    def set_number_of_games(games)
      @number_of_games = games.to_i
    end

    #--Messages--------------------------------------------------------------

    def message(select, exp1, exp2)
      message = {
        "welcome"               =>  "Welcome to Mastermind!",
        "rules"                 =>  "Here's how to play...",
        "set_games"             =>  "Enter games to be played (#{exp1}..#{exp2}).",
        "code_maker_instruct"   =>  "These are instructions for making a code.",
        "code_breaker_instruct" =>  "These are instructions for breaking a code.",
        "code_prompt"           =>  "Enter your #{exp1}-digit code:",
        "guess_limit"           =>  "You are out of guesses.",
        "win"                   =>  "You've won the match!",
        "lose"                  =>  "I'm #1 -- You've lost the match!"
      }

      message[select]
    end

    #--Setup-----------------------------------------------------------------

    def welcome
      message("welcome", "", "")
    end

    def rules
      message("rules", "", "")
    end

    def number_of_games_prompt
      message("set_games", MIN_GAMES, MAX_GAMES)
    end

    def validate_game_to_be_played(games)
      if is_numeric?(games) == true && games.between?(MIN_GAMES, MAX_GAMES)
        set_number_of_games(games)
      else
        number_of_games_prompt
      end
    end

    def player_select_prompt
      "Enter 'cm' or 'cb'."
    end

    def validate_player(selection)
      unless selection == "cm" || selection == "cb"
        player_select_prompt
      else
        if selection == "cm"
          code_maker
        else selection == "cb"
          code_breaker
        end
        i_am_player(selection)
      end
    end

    def instructions
      if @i_am_player == "cm"
        message("code_maker_instruct","","")
      else
        message("code_breaker_instruct","","")
      end
    end

    #--Start Game----------------------------------------------------------------
      def alternate_players
        (@i_am_player == "cm") ? i_am_player("cb") : i_am_player("cm")
      end

      def start_play
       (@i_am_player == "cb") ? code_breaker_start : code_maker_start
      end

      def code_breaker_start
      end

      def code_maker_start
      end

    #--Code----------------------------------------------------------------------

    def code_prompt
      message("code_prompt", CODE_SIZE, "")
    end

    def validate_code(code)
      if is_numeric?(code) && code.size == CODE_SIZE
        code.split("").all? do |x|
          x.to_i.between?(FLOOR_DIGIT, CEILING_DIGIT)
        end
      else
        false
      end
    end


    def auto_code
      code = ""
      until code.size == CODE_SIZE do
        random_pick = rand(CEILING_DIGIT) + 1
        if random_pick.between?(FLOOR_DIGIT, CEILING_DIGIT)
          code << random_pick
        end
      end

      set_code(code)
    end

    #--Guessing----------------------------------------------------------------

    def code_breaker(code)
      code_to_break = @set_code.split("")
      guess = code.split("")
      marker =""

      CODE_SIZE.times do |x|
        if guess[x] == code_to_break[x]
          marker << "+"
        else
          marker << "-"
        end
      end

      marker
    end

    def guess_tracker(guess)
      @guesses << guess
    end

    def count_guesses
      @guesses.size
    end

    def guess_limit_reached
      if count_guesses == ALLOWED_GUESSES
        message("guess_limit", "", "")
      end
     end

     #--Score-Keeping----------------------------------------------------------------
     def calc_score(guess)
      if guess != @set_code
        @code_maker_score += 1
      end
     end

     def code_breaker_wins?
      (@guesses.last == "++++") ? true : false
     end

     def code_maker_wins?
      (count_guesses == ALLOWED_GUESSES && code_breaker_wins? == false ) ? true : false
     end

     def match_winner
      (@i_am_player_score > @ai_score) ? message("win","","") : message("lose","","")
     end
     
     def i_am_player_score
       @i_am_player_score += 1
     end

     def ai_score
       @ai_score += 1
     end
     
     
     #--Next-Game--------------------------------------------------------------------
     def game_tracker
      if @games_played < @number_of_games
        @games_played += 1
      end
     end


  end
end