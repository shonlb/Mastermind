class Faker

=begin
  This class creates a collection of comments for for use in pass/fail
  scenarios. These comments or "test doubles" stand in versus processng the
  real STDOUT. If the instance variable @output has not been set, then it is set
  to be a new instance of this class Fake_output.  Once initialized, every time
  called thereafter, the same Faker object is returned. This is a caching
  technique called memoization.
=end

  def msg_updater
    # @message_collection is an instance variable
    # if @message_collection == nil then set to an empty array
    @message_collection ||= []
  end

  def puts(message)
    #append message to @messages_collection by calling msg_updater
    msg_updater << message
  end
end

def this_faker
  # @this_faker is an instance variable
  # if @this_faker == nil then set as a new instance of the class Fake_output
  @this_faker ||= Faker.new
end

def set_max_games(max_games)
  @max_games = max_games
end

def set_player(i_am_player)
  @i_am_player = i_am_player
end

#-- Step Definitions ---------------------------------------------------

Given /^I am not yet playing$/ do
end

When /^I start a new game$/ do
  game = Mastermind::Game.new(this_faker, nil, nil, nil)
  game.setup(1, 2) #enter any arguments except nil for this test
end


Then /^I should see "([^"]*)"$/ do |alert_msg|
  @this_faker.msg_updater.should include(alert_msg)
end

And /^I am prompted "([^"]*)"$/ do |alert_msg|
  @this_faker.msg_updater.should include(alert_msg)
  game.setup(1,2) #enter any value
end

Given /^the minimum is "([^"]*)" and the maximum is "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

When /^I enter "([^"]*)" I should see "([^"]*)"Let's try again\.\\n So, how many games shall we play\? Enter an even number from (\d+) to (\d+)\."([^"]*)"$/ do |arg1, arg2, arg3, arg4, arg5|
  pending # express the regexp above with the code you wish you had
end

When /^I enter "([^"]*)" I should see "([^"]*)"OK \-\- we will play (\d+) games\."([^"]*)"$/ do |arg1, arg2, arg3, arg4|
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
