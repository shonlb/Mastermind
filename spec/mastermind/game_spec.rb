require "spec_helper"

module Mastermind
  describe "Game" do
    #--code simulators-----------------------------------
    def message(selection, exp1, exp2)
      show ={
        "welcome"               =>  "Welcome to Mastermind!",
        "rules"                 =>  "Here's how to play...",
        "set_matches"           =>  "Enter matches to be played (#{exp1}..#{exp2}).",
        "match_confirm"         =>  "Game consists of #{exp1} matches.",
        "match_display"         =>  "Match #{exp1} of #{exp2}",
        "get_role"              =>  "Who will be? Enter \"cm\" for Code Maker or \"cb\" for Code Breaker",
        "confirm_role"          =>  "You are the #{exp1}",
        "code_maker_instruct"   =>  "These are instructions for making a code.",
        "code_breaker_instruct" =>  "These are instructions for breaking a code.",
        "code_prompt"           =>  "Enter your #{exp1}-digit code:",
        "guess_limit"           =>  "You are out of guesses.",
        "win"                   =>  "You've won the match!",
        "lose"                  =>  "I'm #1 -- You've lost the match!"
      }
      show[selection]
    end    
    
    #--objects-------------------------------------------
    let(:output) {double("output").as_null_object}
    let(:launch) {Launch.new(output)}
    
    #--tests---------------------------------------------    
    describe "# Messages" do
      it "shows a welcome message" do
        output.should_receive(:puts).with(message("welcome", "", ""))
        launch.welcome
      end
      
      it "shows game rules" do
        output.should_receive(:puts).with(message("rules", "", ""))
        launch.rules
      end
      
      it "prompts for the number of games to be played" do
        output.should_receive(:puts).with(message("match_prompt", 6, 20))
        launch.match_prompt
      end
      
      it "confirms games to be played" do
        launch.set_matches(6)
        output.should_receive(:puts).with(message("match_confirm", 6, ""))
        launch.match_confirm      
      end
      
      it "updates games to be played" do
        
      end
      
      it "shows code maker instructions"do
        output.should_receive(:puts).with(message("code_maker_instruct", "", ""))
        launch.code_maker_instructions
      end
      
      it "shows code breaker instructions"
      it "prompts the code maker for a code"
      it "prompts the code breaker for a guess"
      it "alerts code breaker is out of guesses"
      it "alerts human player of a win"
      it "alerts human player of a loss"
    end
    
    describe "# User Input" do
      it "gets number of matches from user" do
        launch.set_matches(6).should == 6
      end
    end
  end
end
