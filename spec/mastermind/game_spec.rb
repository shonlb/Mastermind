require "spec_helper"

class FakeMessageOut
  attr_reader :message
  
  def puts(message)
    @message = message
  end
end

class FakeStdIn
  attr_reader :entry
  
  def gets(input)
    @input = input
  end
end

module Mastermind
  describe "Game" do
    #objects------------------------------------------------------------------------
    #let(:output) {double("output").as_null_object}
    let(:output) { FakeMessageOut.new }
    let(:input) {FakeStdIn.new}
    let(:display) {Display.new}
    let(:game) {Game.new(output, input)}
    
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
        "code_prompt"           =>  "Enter your #{exp1}-digit #{exp2}:",
        "guess_limit"           =>  "You are out of guesses.",
        "current_match"         =>  "Now playing Match: #{exp1} of #{exp2}",
        "win"                   =>  "You've won the match!",
        "lose"                  =>  "I'm #1 -- You've lost the match!"
      }

      message[select]
    end
    
    def code_grid(code)
      border = "+---+---+---+---+\n"
      cells =""
      cap = "|\n"
      digit = code.split("").each do |x|
        cells << "| #{x} "
      end
      grid =  "CODE TO BREAK/n#{border}#{cells}#{cap}#{border}"
    end

    def guess(guess)
      row = ""
      digit = guess.split("")
      digit.each do |show|
        row << "|  #{show}  "
      end
      grid = "#{row}|\n"
    end
    
    def guesses(guesses)
      grid = ""
      border = "+----------+-----+-----+-----+-----+\n"
      guesses.size.times do |row|
        grid << border
        grid << "| Guess #{row + 1}: "
        grid << guess(guesses[row])
      end
      grid << border
    end
    
    def stage_guess(role, guess, code)
      game.create_human_player(role)
      game.create_ai_player
      game.set_current_players
      game.code_breaker.set_guess(guess, code)
    end
    
    #tests--------------------------------------------------------------------------
    describe "#game setup" do
      it "displays welcome" do
        #output.should_receive(:puts).with(message("welcome", "", ""))
        game.display.message("welcome", "", "")
        output.message.should == message("welcome", "", "")
      end
      
      it "displays game rules" do
        #output.should_receive(:puts).with(message("rules", 6, 20))
        game.display.message("rules", "", "")
        output.message.should == message("rules", "", "")
      end
      
      it "prompts for the number of matches" do
        #output.should_receive(:puts).with(message("match_prompt", 6, 20))
        game.display.message("match_prompt", 6, 20)
        output.message.should == message("match_prompt", 6, 20)
      end
      
      it "gets the number of matches for the game"
      
      it "validates matches entered: invalid" do
        game.matches.is_valid?("m") == false
      end
      
      it "validates matches entered: valid" do
        game.matches.is_valid?("6") == true
      end
      
      it "validates matches entered: invalid" do
        game.matches.is_valid?("35") == false
      end
      
      it "sets matches to be played" do
        game.set_match_count("6").should == 6
      end
    end
    
    describe "#role setting: human is the 'Code Maker'" do
      it "prompts human player for role" do
        #output.should_receive(:puts).with(message("role_prompt", "", ""))
        game.display.message("role_prompt", "", "")
        output.message.should == message("role_prompt", "", "")
      end
      
      it "gets the role input"
      
      it "validates the role input" do
        game.valid_role?("cm").should == true  
      end
      
      it "creates human player as 'Code Maker'" do
        game.create_human_player("cm")
        game.human_player.role.should == "Code Maker"    
      end
      
      it "creates ai player as 'Code Breaker" do
        game.create_human_player("cm")
        game.create_ai_player
        game.ai_player.role.should == "Code Breaker"
      end
      
      it "sets the current player (player having Code Breaker role)" do
        game.create_human_player("cm")
        game.create_ai_player
        game.set_current_players
        game.code_breaker.should == game.ai_player  
      end
      
      it "sets the current player (player having Code Maker role)" do
        game.create_human_player("cm")
        game.create_ai_player
        game.set_current_players
        game.code_maker.should == game.human_player  
      end
            
      it "displays role confirmation" do
        game.create_human_player("cm")
        #output.should_receive(:puts).with(message("confirm_role"), game.human_player.role)
        game.display.message("confirm_role", game.human_player.role, "")
        output.message.should == message("confirm_role", game.human_player.role, "")
      end
    end
    
    describe "# launch Code maker" do
      it "sets_the_current_match" do
        game.matches.set_current
        game.matches.current_match.should == 1
      end
      
      it "displays current match" do
        game.set_match_count(6)
        game.matches.set_current
        game.display.message("current_match", game.matches.current_match, game.matches.match_count)
      end
      
      it "validates the code: valid" do
        game.code.is_valid?("1111").should == true
      end
      
      it "validates the code: invalid" do
        game.code.is_valid?("8888").should == false
      end
      
      it "generates code: ai player is the code maker" do
        game.create_human_player("cb")
        game.create_ai_player
        game.set_current_players
        code = game.code_maker.generate_code
        game.code.is_valid?(code).should == true
      end
      
      it "prompts for code: human player is the code maker" do
        game.display.message("code_prompt", "", "")
        output.message.should == message("code_prompt", "", "")
      end
      
      it "gets the code from human_player"
      
      it "sets the code" do
        game.set_code("1111")
        game.code.code.should == "1111"  
      end
    end
      
    describe "#code breaker" do
      it "displays the code to be broken: human is code maker" do
        game.display.code_grid("2346")
        output.message.should == code_grid("2346") 
      end
        
      it "guesses: ai player is the code breaker" do
        game.create_human_player("cm")
        game.create_ai_player
        code_size = game.code.code_size
        min_digit = game.code.min_digit
        max_digit = game.code.max_digit
        game.set_current_players
        guess = game.code_breaker.generate_guess
        game.code_breaker.guesses << guess
        game.ai_player.guesses.size.should == 1
      end
        
      it "compares the ai player's last guess to the code: no match" do
        role = "cm"
        guess = "1111"
        code = "2222"
        stage_guess(role, guess, code)
        game.code_breaker.guesses.last.should == "----"
      end
        
      it "displays all guesses" do
        role = "cm"
        guess = "1111"
        code = "1212"
        stage_guess(role, guess, code)
        game.display.guesses(game.code_breaker.guesses)
        output.message.should == guesses(game.code_breaker.guesses)
      end        
        
    end
  end
end