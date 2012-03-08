require 'spec_helper'

=begin
class FakeStdOut
  attr_reader :message_collection

  def initialize
    @message_collection = []
  end

  def puts(message)
    @message_collection << message
  end
end

class FakeStdIn
  attr_writer :input

  def gets
    "#{input}\n"
  end
end

=end
#--------------------------------------
module Mastermind
  describe "Game" do

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

    describe "#setup" do

      it "sends a welcome message" do
        game.welcome.should == "Welcome to Mastermind!"
      end

      it "displays game rules" do
        game.rules.should == "Here's how to play..."
      end

      it "prompts for number of games to be played" do
        game.number_of_games_prompt.should == "Enter games to be played (6..20)."
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
        game.instructions.should == "These are the instructions for making a code."
      end

      it "validates 'cb' selection" do
        game.i_am_player("cb")
        game.instructions. should == "These are the instructions for breaking a code."
      end

      it "prompts to select player if initial selection is invalid" do
        tests = ['1','2','b','cmb','cbm', 'as12']
        tests.each do |x|
          game.validate_player(x) == game.player_select_prompt
        end
      end
    end

    describe "#code_making" do
      it "auto-generates a code to be broken by the human" do
        game.auto_code.size.should == 4
      end

      it "prompts for the code" do
        game.code_prompt.should == "Enter your 4-digit code:"
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
          game.validate_code(x).should == game.code_prompt
        end
      end

      it "prompts for the code if any of the digits are out of range" do
        tests = ["0364", "6578", "9090"]
        tests.each do |x|
          game.validate_code(x).should == game.code_prompt
        end
      end

    end

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
        game.guess_limit_reached.should == "You are out of guesses."
      end
    end

    describe "#score-keeping" do
      it "calculates score for a bad guess" do
        guess = "6552"
        game.set_code("6124")
        game.code_breaker(guess)
        game.calc_score(guess).should == 1
      end

      it "validates that the code-breaker has won" do
        guess = "6552"
        game.set_code(guess)
        guess_simulator(guess)
        game.code_breaker_wins?.should == true
      end

      it "validates that the code-maker has won" do
        guess = "6552"
        game.set_code("6124")
        6.times do
          guess_simulator(guess)
        end
        game.code_maker_wins?.should == true
      end
    end

    describe "#next_game" do
      it "updates the total games played" do
        setup_simulator("cb", 7)
        game.game_tracker.should == 1
      end

      it "alternates player roles"
      it "starts next game"
    end

    describe "#match winner" do
      it "announces that the human player has won the match"
      it "announces that the ai player has won the match"
    end
  end
end