module Mastermind
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
end