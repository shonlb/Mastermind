module Mastermind

  class Game

    #--Helpers----------------------------------------------------------------

    def is_numeric?(s)
        !!Float(s) rescue false
    end

    #--Variables--------------------------------------------------------------

    def initialize
      @code_size = 4
      @floor_digit = 1
      @ceiling_digit = 6
      @min_games = 6
      @max_games = 20
      @number_of_games = 0
      @games_played = 0
      @guesses = []
      @cm_score = 0
      @i_am_player_score = 0
      @ai_score = 0
    end

    def i_am_player(player)
      @i_am_player = player
    end

    def set_code(code)
      @set_code = code
    end

    def set_number_of_games(games)
      @number_of_games = games.to_i
    end

    #--Setup-----------------------------------------------------------------

    def welcome
      "Welcome to Mastermind!"
    end

    def rules
      "Here's how to play..."
    end

    def number_of_games_prompt
      "Enter games to be played (#{@min_games}..#{@max_games})."
    end

    def validate_game_to_be_played(games)
      if is_numeric?(games) == true && games.between?(@min_games, @max_games)
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
        "These are the instructions for making a code."
      else
        "These are the instructions for breaking a code."
      end
    end

    #--Code----------------------------------------------------------------------

    def code_prompt
      "Enter your #{@code_size}-digit code:"
    end

    def validate_code(code)
      if is_numeric?(code) && code.size == @code_size
        i = 0
        checker = true

        until i == @code_size || checker == false do
          checker = code[i].chr.to_i.between?(@floor_digit, @ceiling_digit)
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
      @code_size.times do |x|
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

     def match_winner
      (@i_am_player_score > @ai_score) ? "You've won the match!" : "I'm #1 -- You've lost the match!"
     end

     #--Next-Game------------------------------------------------------------------------------
     def game_tracker
      if @games_played < @number_of_games
        @games_played += 1
      end
     end
  end
end