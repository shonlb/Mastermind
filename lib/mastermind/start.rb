module Mastermind
  class Start
    def initialize
      @play = Game.new(STDOUT, STDIN)
    end
  
    def playing
      @play.game_play
    end
  end
end

if __FILE__
  GameRunner.start
end