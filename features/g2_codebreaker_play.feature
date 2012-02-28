Feature: Human player is the codebreaker

  As the codebreaker
  I will enter a guess of up to 4 numbers between 1 and 6
  I can enter duplicate values
  My goal is to solve the code

  Scenario Outline:
  Given the secret code is "<code>"
  When I guess "<guess>"
  Then the mark should be "<mark>"

    Scenarios: 4 correct
    | code | guess | mark |
    | 1234 | 1234  | ++++ |

    Scenarios: 3 correct
    | code | guess | mark |
    | 1234 | 6234  | -+++ |

    Scenarios: 2 correct
    | code | guess | mark |
    | 1234 | 5236  | -++- |

    Scenarios: 1 correct
    | code | guess | mark |
    | 1234 | 1456  | +--- |

    Scenarios: 0 correct
    | code | guess | mark |
    | 1234 | 4546  | ---- |