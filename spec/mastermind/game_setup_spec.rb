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

    describe "#setup" do

      it "sends a welcome message" do
        game.welcome.should == "Welcome to Mastermind!"
      end

      it "displays game rules" do
        game.rules.should == "Here's how to play..."
      end

      it "prompts for number of games to be played" do
        game.number_of_games.should == "Enter games to be played (6..20)."
      end

      it "asks for number of games if entry is not numeric" do
        tests = ['',' ','b','b123']
        tests.each do |x|
          game.validate_game_to_be_played(x).should == game.number_of_games
        end
      end

      it "asks for number of games if entry is out of range" do
        tests = [0,1,2,3,4,5,21,22,99]
        tests.each do |x|
          game.validate_game_to_be_played(x).should == game.number_of_games
        end
      end

      it "prompts to select player" do
        tests = [6,7,12,15,20]
        tests.each do |x|
          game.validate_game_to_be_played(x).should == game.player_select
        end
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
          game.validate_player(x) == game.player_select
        end
      end
    end

    describe "#code_making" do
      it "auto-generates a code to be broken by the human"

      it "prompts for the code" do
        game.code_prompt.should == "Enter your 6-digit code:"
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

      it "tracks the number of guesses" do

      end
    end
  end
end