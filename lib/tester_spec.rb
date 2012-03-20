require 'spec_helper'
module Mastermind
  describe "Game" do

  let(:show) {double("show").as_null_object}
  let(:display) {Display.new(show)}
  let(:game) {Game.new}
  
  def setup_simulator(i_am_player, games_to_play)
    game.i_am_player(i_am_player)
    game.set_number_of_games(games_to_play)
  end

  def guess_simulator(guess)
    game.guess_tracker(game.code_breaker(guess))
    game.calc_score(guess)
    game.code_breaker_wins?
  end

  def message(select, exp1, exp2)
    message = {
      "welcome"               =>  "Welcome to Mastermind!",
      "rules"                 =>  "Here's how to play...",
      "set_games"             =>  "Enter games to be played (#{exp1}..#{exp2}).",
      "code_maker_instruct"   =>  "These are instructions for making a code.",
      "code_breaker_instruct" =>  "These are instructions for breaking a code.",
      "code_prompt"           =>  "Enter your #{exp1}-digit code:",
      "guess_limit"           =>  "You are out of guesses.",
      "win"                   =>  "You've won the match!",
      "lose"                  =>  "I'm #1 -- You've lost the match!"
    }

    message[select]
  end

    describe "#setup" do

      it "sends a welcome message" do
        game.show.should_receive(:puts).with(message("welcome", "",""))
        display.welcome
      end

      it "displays game rules" do
        show.should_receive(:puts).with(message("rules", "",""))
        display.rules
      end

      it "prompts for number of games to be played" do
        show.should_receive(:puts).with(message("set_games", 6, 20))
        display.set_games(6, 20)
      end


      it "asks for number of games if entry is not numeric" do
        tests = ['',' ','b','b123']
        tests.each do |x|
          game.validate_game_to_be_played(x).should == game.number_of_games_prompt
        end
      end

      it "asks for number of games if entry is out of range" do
        tests = [0,1,2,3,4,5,21,22,99]
        tests.each do |x|
          game.validate_game_to_be_played(x).should == game.number_of_games_prompt
        end
      end

      it "sets the number of games" do
        game.set_number_of_games(7).should == 7
      end

      it "validates 'cm' selection" do
        game.i_am_player("cm")
        game.instructions.should == message("code_maker_instruct", "", "")
      end

      it "validates 'cb' selection" do
        game.i_am_player("cb")
        game.instructions. should == message("code_breaker_instruct", "", "")
      end

      it "prompts to select player if initial selection is invalid" do
        tests = ['1','2','b','cmb','cbm', 'as12']
        tests.each do |x|
          game.validate_player(x) == game.player_select_prompt
        end
      end
    end

    #--Start Play----------------------------------------------------------------------------

    describe "#start playing" do
      it "starts the game for when the human player is the code-breaker" do
        setup_simulator("cb", 7)
        game.start_play.should == game.code_breaker_start
      end

      it "starts the game for when the human player is the code-maker" do
        setup_simulator("cm", 7)
        game.start_play.should == game.code_maker_start
      end

      it "alternates player roles" do
        setup_simulator("cb",7)
        game.alternate_players.should == "cm"
      end
    end

    describe "#code-maker start" do
    end

    describe "code-breaker start" do
    end

    #--Code Making---------------------------------------------------------------------------
    describe "#code_making" do
      it "auto-generates a code to be broken by the human" do
        game.auto_code.size.should == 4
      end

      it "prompts for the code" do
        game.code_prompt.should == message("code_prompt", 4, "")
      end

      it "validates the code is numeric" do
        game.is_numeric?("1234").should == true
      end

      it "validates the code is not numeric" do
        game.is_numeric?("pa2l").should == false
      end

      it "prompts for the code if it is an invalid length" do
        tests = ["1","12", "345", "123456"]
        tests.each do |x|
          game.validate_code(x).should == false
        end
      end

      it "prompts for the code if any of the digits are out of range" do
        tests = ["0364", "6578", "9090"]
        tests.each do |x|
          game.validate_code(x).should == false
        end
      end

    end

    #--Code Breaking--------------------------------------------------------------------------
    describe "#guessing" do
      it "compares the guess to the generated code - exact match" do
        game.set_code("6214")
        game.code_breaker("6214").should == "++++"
      end

      it "compares the guess to the generated code - 3 matches" do
        game.set_code("6214")
        tests = {
          "1214" => "-+++",
          "6314" => "+-++",
          "6254" => "++-+",
          "6216" => "+++-"
        }

        tests.each do |key, value|
          game.code_breaker(key).should == value
        end
      end

      it "compares the guess to the generated code - 2 matches" do
        game.set_code("6214")
        tests = {
          "1215" => "-++-",
          "6364" => "+--+",
          "6251" => "++--",
          "1114" => "--++"
        }

        tests.each do |key, value|
          game.code_breaker(key).should == value
        end
      end

      it "compares the guess to the generated code - 1 match" do
        game.set_code("6214")
        tests = {
          "6155" => "+---",
          "5233" => "-+--",
          "3316" => "--+-",
          "1134" => "---+"
        }

        tests.each do |key, value|
          game.code_breaker(key).should == value
        end
      end

      it "compares the guess to the generated code - no matches" do
        game.set_code("6214")
        game.code_breaker("3425").should == "----"
      end

      it "tracks guesses in an array" do
        game.guess_tracker("++--").should == ["++--"]
      end

      it "counts the number of guesses made" do
        3.times do
          game.guess_tracker("++--")
        end
        game.count_guesses.should == 3
      end

      it "alerts when 6 guesses have been made" do
        6.times do
          game.guess_tracker("++--")
        end
        game.guess_limit_reached.should == message("guess_limit", "", "")
      end
    end

    #--Score Keeping---------------------------------------------------------------------------
    describe "#score-keeping" do
      it "calculates score for a bad guess" do
        guess = "6552"
        game.set_code("6124")
        game.code_breaker(guess)
        game.calc_score(guess).should == 1
      end

    end

    describe "#next_game" do
      it "updates the total games played" do
        setup_simulator("cb", 7)
        game.game_tracker.should == 1
      end

    end

    #--Match Winner------------------------------------------------------------------------
    describe "#Winner" do
      it "validates that the code-breaker has won the current game" do
        guess = "6552"
        game.set_code(guess)
        guess_simulator(guess)
        game.code_breaker_wins?.should == true
      end

      it "validates that the code-maker has won the current game" do
        guess = "6552"
        game.set_code("6124")
        6.times do
          guess_simulator(guess)
        end
        game.code_maker_wins?.should == true
      end

      it "updates the game score for the code-maker: human" do
        game.i_am_player_score.should == 1  
      end
      
      it "updates the game score for the code-maker: ai" do
        game.ai_score.should == 1
      end
      it "announces that the human player has won the match" do
        game.i_am_player_score
        game.match_winner.should == message("win", "", "")
      end
      it "announces that the ai player has won the match" do
        game.ai_score
        game.match_winner.should == message("lose", "", "")
      end
    end
    describe 
  end
end