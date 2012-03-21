require "spec_helper"

module Mastermind
  describe "Game" do
    #objects------------------------------------------------------------------------
    let(:output) {double("output").as_null_object}
    let(:display) {Display.new}
    let(:game) {Game.new(output)}
    
    #game_simulators----------------------------------------------------------------
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
        "code_prompt"           =>  "Enter your #{exp1}-digit code:",
        "guess_limit"           =>  "You are out of guesses.",
        "win"                   =>  "You've won the match!",
        "lose"                  =>  "I'm #1 -- You've lost the match!"
      }

      message[select]
    end
    
    def game_setup(matches, role)
      game.setup(matches, role)
    end
    
    #tests--------------------------------------------------------------------------
    describe "#game setup" do
      it "displays welcome" do
        output.should_receive(:puts).with(message("welcome", "", ""))
        game.show_welcome
      end
      
      it "displays game rules" do
        output.should_receive(:puts).with(message("rules", 6, 20))
        game.show_rules
      end
      
      it "prompts for the number of matches" do
        output.should_receive(:puts).with(message("match_prompt", 6, 20))
        game.show_match_prompt
      end
      
      it "gets the number of matches for the game" do
        game.get_match_count("6").should == "6"
      end
      
      it "validates matches entered: invalid" do
        game.validate("match_count", "m") == false
      end
      
      it "validates matches entered: valid" do
        game.validate("match_count", "6") == true
      end
      
      it "sets matches to be played" do
        game.set_match_count(game.get_match_count("6")).should == 6
      end
    end
    
    describe "#role setting: human is the 'Code Maker'" do
      it "prompts human player for role" do
        output.should_receive(:puts).with(message("role_prompt", "", ""))
        game.show_role_prompt
      end
      
      it "gets the role input" do
        game.get_role("cm").should == "cm"  
      end
      
      it "validates the role input" do
        game.validate("role", "cm").should == true  
      end
      
      it "creates human player as 'Code Maker'" do
        game.create_human_player("cm")
        game.human_player.role.should == "Code Maker"    
      end
      
      it "creates ai player as 'Code Breaker" do
        game.create_ai_player("cm")
        game.ai_player.role.should == "Code Breaker"
      end
      
      it "sets the current player (player having Code Breaker role)" do
        game.create_human_player("cm")
        game.create_ai_player(game.human_player.role)
        game.set_current_player.should == game.ai_player  
      end
      
      it "displays role confirmation" do
        game.create_human_player("cm")
        output.should_receive(:puts).with(message("confirm_role"), game.human_player.role)
        game.show_role_confirmation
      end
    end
  end
end