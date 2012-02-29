require 'spec_helper'

=begin
  As an alternative building a Fake_output class for messages, avialable in the
  RSpec library is a class called Mocks which simplifies creating test doubles.
  The double() method creates a double. This double "stands in" for STDOUT.
=end

def alert_messages(pick, other_value)
  @alert_msg = {
    "welcome"             => "Welcome to Mastermind! How clever are you?",
    "game_rules"          => "[Insert rules here.]",
    "game_count_prompt"   => "So, how many games shall we play? Enter an even number from 6 to 20.",
    "game_count_confirm"  => "OK -- we will play #{other_value} games.",
    "player_prompt"       => "Who will you be first? Enter 'm' for 'Code Maker' or 'b' for 'Code Breaker'.",
    "breaker"             => "OK.  I am the Code Maker. Break it if you can!",
    "maker"               => "OK, Code Maker. Give me your best shot!",
    "invalid"             => "Let' try again.",
    "code_prompt"         => "Set your coded by entering any 4 digits from 1 to 6. Duplicates are allowed.",
    "code_set"            => "OK -- The code has been set, Let's Play!"
  }

    @alert_msg[pick]
end


#-----------------------------------------------------------------------------

module Mastermind
  describe Game do

    let(:test_msg) { double('test_msg').as_null_object }
    let(:game) { Game.new(test_msg, nil, nil, nil) }

    describe "#setup" do
      it "sends a welcome message" do
        test_msg.should_receive(:puts).with(alert_messages("welcome", ""))
        game.setup
      end

      it "displays the game rules" do
        test_msg.should_receive(:puts).with(alert_messages("game_rules", ""))
        game.setup
      end
    end

    describe "#invalid entries for set_max_games" do
      tests = [0, 1, 2, 3, 7, 9, 11, 22, 21, '']

      tests.size.times do |x|
        it "sends an error alert for #{tests[x]}" do
          test_msg.should_receive(:puts).with(alert_messages("game_count_prompt", ""))
          test_msg.should_receive(:puts).with(alert_messages("invalid", ""))
          game.set_max_games(tests[x])
        end
      end
    end

    describe "#valid entries for set_max_games" do
      tests = [6, 8, 14, 18, 20]

      tests.size.times do |x|
        it "confirms games to be played = #{tests[x]}" do
          test_msg.should_receive(:puts).with(alert_messages("game_count_prompt", ""))
          test_msg.should_receive(:puts).with(alert_messages("game_count_confirm", tests[x]))
          game.set_max_games(tests[x])
        end
      end
    end

    describe "# invalid entry response for player selection" do
      tests = ['c', '3', 'ref', ' ', '']

      tests.size.times do |x|
        it "sends error message for #{tests[x]} " do
          test_msg.should_receive(:puts).with(alert_messages("invalid", ""))
          game.select_player(tests[x])
        end
      end
    end

    describe "# valid entry response for player selection" do
      tests = ['b', 'm']

      tests.size.times do |x|
        it "validates the player selection #{tests[x]} " do
          case tests[x]
            when "b"
              test_msg.should_receive(:puts).with(alert_messages("breaker", ""))
            when "m"
              test_msg.should_receive(:puts).with(alert_messages("maker", ""))
          end
          game.select_player(tests[x])
        end
      end
    end

    describe "# cpu generates code with invalid entries" do
      it "generates a numeric series of 4 numbers each >=1 and <=6" do
      end
    end

  end
end
