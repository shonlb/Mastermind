Feature: Human player sets game options

  As the human player
  I will select how many games will be played
  I will choose to be either the "code breaker" or the "code maker"

  Scenario: game setup
    Given I am not yet playing
    When I start a new game
    Then I should see "Welcome to Mastermind! How clever are you?"
    And I should see the game rules
    And I am prompted "How many games will we play?"
    And I am prompted "Who will you be first? Enter 'm' for 'Code Maker' or 'b' for 'Code Breaker'."