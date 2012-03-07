module Mastermind

  class Game

    #--Helpers----------------------------------------------------------------

    def is_numeric?(s)
        !!Float(s) rescue false
    end

    #--Variables--------------------------------------------------------------

    def initialize
      @guesses = []
      @cm_score = 0
    end

    def i_am_player(player)
      @i_am_player = player
    end

    def set_code(code)
      @set_code = code
    end

    #--Setup-----------------------------------------------------------------

    def welcome
      "Welcome to Mastermind!"
    end

    def rules
      "Here's how to play..."
    end

    def number_of_games
      "Enter games to be played (6..20)."
    end

    def validate_game_to_be_played(games)
      if is_numeric?(games) == true && games.between?(6,20)
        player_select
      else
        number_of_games
      end
    end

    def player_select
      "Enter 'cm' or 'cb'."
    end

    def validate_player(selection)
      unless selection == "cm" || selection == "cb"
        player_select
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
        "These are the instructions for making a code."
      else
        "These are the instructions for breaking a code."
      end
    end

    #--Code----------------------------------------------------------------------

    def code_prompt
      "Enter your 6-digit code:"
    end

    def validate_code(code)
      if is_numeric?(code) && code.size == 4
        i = 0
        checker = true

        until i == 4 || checker == false do
          checker = code[i].chr.to_i.between?(1,6)
          i+= 1
        end

        if checker == false
          code_prompt
        end
      else
        code_prompt
      end
    end

    def auto_code
      code = []
      4.times do |x|
        code << rand(6) + 1
      end
      set_code(code)
      code
    end

    #--Guessing----------------------------------------------------------------

    def code_breaker(code)
      check_code = ""
      i = 0
      until i == 4 do
        if code[i].chr.to_i == @set_code[i].chr.to_i
          check_code << "+"
        else
          check_code << "-"
        end
        i += 1
      end
      check_code
    end

    def guess_tracker(guess)
      @guesses << guess
    end

    def count_guesses
      @guesses.size
    end

    def guess_limit_reached
      if count_guesses == 6
        "You are out of guesses."
      end
     end

     #--Score-Keeping-------------------------------------------------------------------------
     def calc_score(guess)
      if guess != @set_code
        @cm_score += 1
      end
     end

     def code_breaker_wins?
      (@guesses.last == "++++") ? true : false
     end

     def code_maker_wins?
      (count_guesses == 6 && code_breaker_wins? == false ) ? true : false
     end
  end
end