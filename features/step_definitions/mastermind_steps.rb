class Fake_output

=begin
  This class creates a collection of comments for for use in pass/fail
  scenarios. If the instance variable @output has not been set, then it is set
  to be a new instance of this class Fake_output.  Once initialized, every time
  called thereafter, the same Fake_output object is returned. This is a caching
  technique called memoization.
=end


  def updates_messages
    # @message_collection is an instance variable
    # if @message_collection == nil then set to an empty array
    @message_collection ||= []
  end

  def adds_messages(message)
    #append message to @messages_collection by calling updates_messages
    updates_messages << message
  end

  def outputs_messages
    # @output is an instance variable
    # if @output == nil then set as a new instance of the class Fake_output
    @output ||= Fake_output.new
  end
end



#-- Step Definitions ---------------------------------------------------

Given /^I am not yet playing$/ do

end

When /^I start a new game$/ do
  # the variable test_msg sends a message to the Fake_output class
  # for appending to @message_collection.
  game = Mastermind::Game.new(test_msg)
  game.setup
end

Then /^I should see "([^"]*)"$/ do |message|
  pending # express the regexp above with the code you wish you had
end

Then /^I should see the game rules$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I am prompted "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Given /^the secret code is "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

When /^I guess "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^the mark should be "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end