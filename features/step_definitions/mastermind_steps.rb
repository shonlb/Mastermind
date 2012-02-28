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

#-- Step Definitions ---------------------------------------------------

Given /^I am not yet playing$/ do
end

When /^I start a new game$/ do
  game = Mastermind::Game.new(this_faker, nil, nil)
  game.setup
end

Then /^I should see "([^"]*)"$/ do |message|
  this_faker.msg_updater.should include message
end

Then /^I am prompted "([^"]*)"$/ do |message|
  this_faker.msg_updater.should include message
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

