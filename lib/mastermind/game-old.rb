module Mastermind
  class Game

    def initialize(test_msg, max_games, i_am_player, alert_msg)
      @test_msg = test_msg
      @max_games = max_games
      @i_am_player = i_am_player
      @alert_msg = alert_msg
    end

    def alert_messages(pick, other_value)
      @alert_msg = {
        "welcome"             => "Welcome to Mastermind! How clever are you?",
        "game_rules"          => "[Insert rules here.]",
        "game_count_prompt"   => "So, how many games shall we play? Enter an even number from 6 to 20.",
        "game_count_confirm"  => "OK -- we will play #{other_value} games.",
        "player_prompt"       => "Who will you be first? Enter 'm' for 'Code Maker' or 'b' for 'Code Breaker'.",
        "breaker"             => "OK.  I am the Code Maker. Break it if you can!",
        "maker"               => "OK, Code Maker. Give me your best shot!",
        "invalid"             => "Let' try again.",
        "code_prompt"         => "Set your coded by entering any 4 digits from 1 to 6. Duplicates are allowed.",
        "code_set"            => "OK -- The code has been set, Let's Play!"
      }

        @alert_msg[pick]
    end

    def game_play(max_games, i_am_player)

      set_max_games(max_games)
      select_player(i_am_player)

      setup(max_games, i_am_player)
      set_max_games(max_games)
      select_player(i_am_player)
    end

    def setup
      @test_msg.puts alert_messages("welcome", "")
      @test_msg.puts alert_messages("game_rules", "")
    end


    def set_max_games(max_games)
      @test_msg.puts alert_messages("game_count_prompt", "")

      g = (max_games == nil) ? gets.chomp : (max_games == '') ? 0 : max_games

      ttl_games = g.to_i

        if ttl_games%2 == 0 and ttl_games >= 6 and ttl_games <= 20
        @max_games = ttl_games
        @test_msg.puts alert_messages("game_count_confirm", ttl_games)
      else
        @test_msg.puts alert_messages("invalid", "")
        if max_games == nil
          set_max_games(max_games)
        end
      end
    end


    def select_player(i_am_player)

      @test_msg.puts alert_messages("player_prompt", "")

      if i_am_player == nil
        i_choose = gets.chomp
      else
        i_choose = i_am_player
      end

      if i_choose == "b" or i_choose == "m"
        @i_am_player = i_choose
        case i_choose
          when "b"
            @test_msg.puts alert_messages("breaker", "")
          when "m"
            @test_msg.puts alert_messages("maker", "")
        end
      else
        @test_msg.puts alert_messages("invalid", "")

        if i_am_player == nil
          select_player(i_am_player)
        else
          @test_msg.puts alert_messages("player_prompt", "")
        end
      end
    end

    def code_generator(who_sets, the_number)

      code_options = [1,2,3,4,5,6]

      if who_sets == "m" #human player is the code maker

      else #cpu is the code maker
        if the_number == nil
        else
          count = 0
          if the_number.size == 4
            code.size.times do |x|
             count += the_number.count(code_options[x])
            end


          else
          end
        end
      end

    end

  end
end