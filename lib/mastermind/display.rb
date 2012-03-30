module Mastermind
  class Display
    def initialize(output)
      @output = output
    end
    
    #--Messages--------------------------------------------------------------
    def message(select, exp1 = "", exp2 = "")
      message = {
        "welcome"               =>  "Welcome to Mastermind!\n",
        "rules"                 =>  "Here's how to play...\n",
        "match_prompt"          =>  "Enter matches to be played (#{exp1}..#{exp2}).\n",
        "match_confirm"         =>  "Game consists of #{exp1} matches.\n",
        "match_display"         =>  "Match #{exp1} of #{exp2}.\n",
        "role_prompt"           =>  "Who will you be? Enter \"cm\" for Code Maker or \"cb\" for Code Breaker.\n",
        "confirm_role"          =>  "You are the #{exp1}.\n",
        "code_maker_instruct"   =>  "These are instructions for making a code.\n",
        "code_breaker_instruct" =>  "These are instructions for breaking a code.\n",
        "code_prompt"           =>  "Enter your #{exp1}-digit #{exp2}:\n",
        "guess_prompt"          =>  "Enter your #{exp1}-digit #{exp2}:\n",
        "code_set"              =>  "The code has been set.\n",
        "guess_limit"           =>  "You are out of guesses.\n",
        "current_match"         =>  "Now playing Match: #{exp1} of #{exp2}.\n",
        "win"                   =>  "You've won the match!\n",
        "lose"                  =>  "I'm #1 -- You've lost the match!\n",
        "try_again"             =>  "Try again.",
        "game_over"             =>  "Thanks for playing! Come again.\n"
      }

      @output.puts message[select]
    end
    
    def code_grid(code)
      border = "      +---+---+---+---+\n"
      cells =""
      cap = "|\n"
      digit = code.split("").each do |x|
        cells << "| #{x} "
      end
      grid =  "#{border}CODE: #{cells}#{cap}#{border}\n"
      @output.puts grid
    end
 
     def guess(guess)
      row = ""
      digit = guess.split("")
      digit.each do |show|
        row << "|  #{show}  "
      end
      grid = "#{row}|\n"
    end
       
    def guesses(all_guesses)
      grid = ""
      border = "+----------+-----+-----+-----+-----+\n"
      all_guesses.size.times do |row|
        grid << border
        grid << "| Guess #{row + 1}: "
        grid << guess(all_guesses[row])
      end
      grid << border
      @output.puts grid
    end
    
    def last_guess(guess, count)
      grid = ""
      border = "+----------+-----+-----+-----+-----+\n"
      grid << border
      grid << "| Guess #{count}: "
      cell = guess.split("")
      
      cell.each do |x|
        grid << "|  #{x}  "
      end
      
      grid << "|\n"
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