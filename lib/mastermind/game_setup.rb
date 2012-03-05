module Mastermind

  class Game

    def is_numeric?(s)
        !!Float(s) rescue false
    end

    #----------------------------------------------------------------

    def i_am_player(player)
      @i_am_player = player
    end

    def set_code(code)
      @set_code = code
    end

    #----------------------------------------------------------------

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
      if is_numeric?(games) == true && games >= 6 && games <= 20
        player_select
      else
        number_of_games
      end
    end

    def player_select
      "Enter 'cm' or 'cb'."
    end

    def validate_player(selection)
      unless selection == "cm" && selection == "cb"
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

    def auto_code
      code = []
      4.times do |x|
        code << rand(6) + 1
      end
      set_code(code)
      code
    end

  end
end













=begin
    def code_checker(code)
      if is_numeric?(code) && code.size == 4
        i = 0
        checker = true
        until checker == false || i == 4 do
          check_value = code.index[i].chr.to_i
          checker = check_value.between(1,6)
          i+=
        end

        if checker == false
          code_prompt
        else
          check_guess
        end
      else
        code_prompt
      end
    end

=end