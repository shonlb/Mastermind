require 'spec_helper'

=begin
  As an alternative building a Fake_output class for messages, avialable in the
  RSpec library is a class called Mocks which simplifies creating test doubles.
  The double() method creates a double. This double "stands in" for STDOUT.
=end

#-----------------------------------------------------------------------------

module Mastermind
  describe Game do
    describe "#setup" do

      # let creates a memoized test_msg method that returns a double object
      let(:test_msg) { double('test_msg').as_null_object }

      # let creates a memoized game method that creates an new instance of the
      # Game class and passes in test_msg
      let(:game) { Game.new(test_msg, nil, nil) }

      it "sends a welcome message" do
        test_msg.should_receive(:puts).with("Welcome to Mastermind! How clever are you?")
        game.setup
      end

      it "displays the game rules" do
        test_msg.should_receive(:puts).with("[Insert rules here.]")
        game.setup
      end

      it "prompts for number of games to play" do
        test_msg.should_receive(:puts).with("So, how many games shall we play? Enter an even number (6 -- 20).")
        game.setup
      end

      it "prompts to select to be either the 'Code Maker' or the 'Code Breaker'"
        #"Who will you be first? Enter 'm' for 'Code Maker' or 'b' for 'Code Breaker'."
    end
  end
end