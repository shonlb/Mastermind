Feature: Human player sets game options

  As the human player
  I will select how many games will be played
  I will choose to be either the "code breaker" or the "code maker"

  Scenario: game setup
    Given I am not yet playing
    When I start a new game
    Then I should see "Welcome to Mastermind! How clever are you?"
    And I should see "[Insert rules here.]"
    And I am prompted "So, how many games shall we play? Enter an even number from 6 to 20."

  Scenario Outline: player sets number of games
    Given the minimum is "<min>" and the maximum is "<max>"
    When I enter "<number>" I should see "<response>"

    Scenarios: number entered < 6
    | min | max | number | response |
    |  6  | 20  |   0    | "Let's try again.\n So, how many games shall we play? Enter an even number from 6 to 20." |
    |  6  | 20  |   1    | "Let's try again.\n So, how many games shall we play? Enter an even number from 6 to 20." |
    |  6  | 20  |   4    | "Let's try again.\n So, how many games shall we play? Enter an even number from 6 to 20." |

    Scenarios: number entered > 20
    | min | max | number | response |
    |  6  | 20  |   30    | "Let's try again.\n So, how many games shall we play? Enter an even number from 6 to 20." |
    |  6  | 20  |   41    | "Let's try again.\n So, how many games shall we play? Enter an even number from 6 to 20." |

    Scenarios: number entered %2 > 0
    | min | max | number | response |
    |  6  | 20  |   7    | "Let's try again.\n So, how many games shall we play? Enter an even number from 6 to 20." |

    Scenarios: number entered is valid
    | min | max | number | response |
    |  6  | 20  |   6    | "OK -- we will play 6 games." |
    |  6  | 20  |   12   | "OK -- we will play 12 games." |
    |  6  | 20  |   20   | "OK -- we will play 20 games." |


  Scenario Outline: player sets who goes first
    Given the number of games have been set to 10
    When I start a new game
    Then I am prompted "Who will you be first? Enter 'm' for 'Code Maker' or 'b' for 'Code Breaker'."