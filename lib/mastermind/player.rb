module Mastermind
  class Player
    attr_accessor :role, :guesses, :score, :wins, :losses
    
    def initialize(role)
      @role = role
      @guesses = []
      @score = 0
      @wins = 0
      @losses = 0
    end
    
  end
end