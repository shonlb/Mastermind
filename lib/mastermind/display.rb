module Mastermind
  class Display
    def initialize(output)
      @output = output
    end
    
    #--Messages--------------------------------------------------------------
    def message(select, exp1, exp2)
      message = {
        "welcome"               =>  "Welcome to Mastermind!",
        "rules"                 =>  "Here's how to play...",
        "match_prompt"          =>  "Enter matches to be played (#{exp1}..#{exp2}).",
        "match_confirm"         =>  "Game consists of #{exp1} matches.",
        "match_display"         =>  "Match #{exp1} of #{exp2}",
        "role_prompt"           =>  "Who will you be? Enter \"cm\" for Code Maker or \"cb\" for Code Breaker",
        "confirm_role"          =>  "You are the #{exp1}",
        "code_maker_instruct"   =>  "These are instructions for making a code.",
        "code_breaker_instruct" =>  "These are instructions for breaking a code.",
        "code_prompt"           =>  "Enter your #{exp1}-digit #{exp2}:",
        "guess_limit"           =>  "You are out of guesses.",
        "current_match"         =>  "Now playing Match: #{exp1} of #{exp2}",
        "win"                   =>  "You've won the match!",
        "lose"                  =>  "I'm #1 -- You've lost the match!",
        "game_over"             =>  "Thanks for playing! Come again."
      }

      @output.puts message[select]
    end
    
    def code_grid(code)
      border = "               +---+---+---+---+\n"
      cells =""
      cap = "|\n"
      digit = code.split("").each do |x|
        cells << "| #{x} "
      end
      grid =  "#{border}CODE TO BREAK: #{cells}#{cap}#{border}\n"
      @output.puts grid
    end
    
    def guesses(all_guesses)
      grid = ""
      border = "+----------+-----+-----+-----+-----+\n"
      all_guesses.size.times do |row|
        grid << border
        grid << "| Guess #{row + 1}: "
        cell = all_guesses[row].split("")
        cell.each do |x|
          grid << "|  #{x}  "
        end
        grid << "|\n"
      end
      grid << border
      @output.puts grid
    end
    
      def stats(player, wins, losses, score)
        stats =  "\n"
        stats << "#{player}: WINS: #{wins}  |  LOSSES: #{losses}  |  POINTS: #{score}\n"
        @output.puts stats
      end
      
      def game_stats(current_match, match_count)
        stats = "\nMatches played: #{current_match} of #{match_count}\n"
        @output.puts stats
      end
    
  end
end