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
        "role_prompt"           =>  "Who will be? Enter \"cm\" for Code Maker or \"cb\" for Code Breaker",
        "confirm_role"          =>  "You are the #{exp1}",
        "code_maker_instruct"   =>  "These are instructions for making a code.",
        "code_breaker_instruct" =>  "These are instructions for breaking a code.",
        "code_prompt"           =>  "Enter your #{exp1}-digit #{exp2}:",
        "guess_limit"           =>  "You are out of guesses.",
        "current_match"         =>  "Now playing Match: #{exp1} of #{exp2}",
        "win"                   =>  "You've won the match!",
        "lose"                  =>  "I'm #1 -- You've lost the match!"
      }

      @output.puts message[select]
    end
    
    def code_grid(code)
      border = "+---+---+---+---+\n"
      cells =""
      cap = "|\n"
      digit = code.split("").each do |x|
        cells << "| #{x} "
      end
      grid =  "CODE TO BREAK/n#{border}#{cells}#{cap}#{border}"
      @output.puts grid
    end
  end
end