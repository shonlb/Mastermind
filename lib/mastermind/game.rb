module Mastermind
  class Game

    def initialize(test_msg, max_games, i_am_player)
      @test_msg = test_msg
      @max_games = max_games
      @i_am_player = i_am_player
    end

    def setup(max_games, i_am_player)
      @test_msg.puts "Welcome to Mastermind! How clever are you?"
      @test_msg.puts "[Insert rules here.]"
      set_max_games(max_games)
      select_player(i_am_player)
    end

    def set_max_games(max_games)
      @test_msg.puts "So, how many games shall we play? Enter an even number from 6 to 20."

      if max_games == nil
        g = gets.chomp
      else
        g = max_games
      end

      ttl_games = g.to_i

      if ttl_games%2 == 0 and ttl_games >= 6 and ttl_games <= 20
        @max_games = ttl_games
        @test_msg.puts "OK -- we will play #{ttl_games} games."
      else
        @test_msg.puts "Let's try again."
        if max_games == nil
          set_max_games(nil)
        else
          new_value=max_games
          (max_games<6) ? new_value=6 : (max_games>20) ? new_value=20 : (max_games%2>0) ? new_value=+1 : new_value
          @test_msg.puts("OK -- as a courtesy, I've selected that we will play #{new_value} games.")
          set_max_games(new_value)
        end
      end
    end

    def select_player(select_player)
      @test_msg.puts "Who will you be first? Enter 'm' for 'Code Maker' or 'b' for 'Code Breaker'."

      if select_player == nil
        i_choose = gets.chomp
      else
        i_choose = select_player
      end

      if i_choose == "b" or i_choose == "m"
        @i_am_player = i_choose
        case i_choose
          when "b"
            @test_msg.puts "OK.  I am the Code Maker. Break it if you can!"
          when "m"
            @test_msg.puts "OK, Code Maker. Give me your best shot!"
        end
      else
        if select_player == nil
          @test_msg.puts "Let's try again"
          select_player(nil)
        else
          @test_msg.puts "Ok then, I'll choose. You will be the Code Breaker"
          select_player("b")
        end
      end
    end

  end
end