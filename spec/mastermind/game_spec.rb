require "spec_helper"

class FakeDisplayOut
  attr_reader :display
  
  def puts(display)
    @display = display
  end
end

class FakeEntryIn
  attr_writer :string
  
  def gets
    @string
  end
end

module Mastermind
  describe "Game" do
    #objects------------------------------------------------------------------------
    #let(:output) {double("output").as_null_object}
    let(:output) { FakeDisplayOut.new }
    let(:input) {FakeEntryIn.new}
    let(:display) {Display.new}
    let(:game) {Game.new(output, input)}
    
    #game_simulators----------------------------------------------------------------
    def user_input (string)
      input.string = string
      game.user_input.should == string
    end
    
    def message(select, exp1="", exp2="")
      message = {
        "welcome"               =>  "Welcome to Mastermind!\n",
        "rules"                 =>  "Here's how to play...\n",
        "match_prompt"          =>  "Enter matches to be played (#{exp1}..#{exp2}).\n",
        "match_confirm"         =>  "Game consists of #{exp1} matches.\n",
        "match_display"         =>  "Match #{exp1} of #{exp2}.\n",
        "role_prompt"           =>  "Who will you be? Enter \"cm\" for Code Maker or \"cb\" for Code Breaker.\n",
        "confirm_role"          =>  "You are the #{exp1}.\n",
        "code_maker_instruct"   =>  "These are instructions for making a code.\n",
        "code_breaker_instruct" =>  "These are instructions for breaking a code.\n",
        "code_prompt"           =>  "Enter your #{exp1}-digit #{exp2}:\n",
        "guess_prompt"          =>  "Enter your #{exp1}-digit #{exp2}:\n",
        "code_set"              =>  "The code has been set.\n",
        "guess_limit"           =>  "You are out of guesses.\n",
        "current_match"         =>  "Now playing Match: #{exp1} of #{exp2}.\n",
        "win"                   =>  "You've won the match!\n",
        "lose"                  =>  "I'm #1 -- You've lost the match!\n",
        "game_over"             =>  "Thanks for playing! Come again.\n"
      }

      message[select]
    end
    
    def code_grid(code)
      border = "               +---+---+---+---+\n"
      cells =""
      cap = "|\n"
      digit = code.split("").each do |x|
        cells << "| #{x} "
      end
      grid =  "#{border}CODE TO BREAK: #{cells}#{cap}#{border}\n"
    end

    def guess(guess)
      row = ""
      digit = guess.split("")
      digit.each do |show|
        row << "|  #{show}  "
      end
      grid = "#{row}|\n"
    end
    
    def guesses(guesses)
      grid = ""
      border = "+----------+-----+-----+-----+-----+\n"
      guesses.size.times do |row|
        grid << border
        grid << "| Guess #{row + 1}: "
        grid << guess(guesses[row])
      end
      grid << border
    end
    
    def last_guess(guess, count)
      grid = ""
      border = "+----------+-----+-----+-----+-----+\n"
      grid << border
      grid << "| Guess #{count}: "
      cell = guess.split("")
      
      cell.each do |x|
        grid << "|  #{x}  "
      end
      
      grid << "|\n"
      grid << border
    end    
    
    def stage_guess(role, guess, code)
      user_input(role)
      game.set_current_players
      game.code_breaker.set_guess(guess, code)
    end
    
    #tests--------------------------------------------------------------------------
    describe "#game setup" do
      it "displays welcome" do
        game.display.message("welcome")
        output.display.should == message("welcome")
      end
      
      it "displays game rules" do
        game.display.message("rules")
        output.display.should == message("rules")
      end
      
      it "prompts for the number of matches" do
        game.display.message("match_prompt", 6, 20)
        output.display.should == message("match_prompt", 6, 20)
      end
      
      it "gets the number of matches for the game" do
        string = "6"
        input.string = string
        game.user_input.should == string
      end 
      
      it "validates matches entered: invalid" do
        game.matches.valid.match_count?("m") == false
      end
      
      it "validates matches entered: valid" do
        game.matches.valid.match_count?("6") == true
      end
      
      it "validates matches entered: invalid" do
        game.matches.valid.match_count?("35") == false
      end
      
      it "sets matches to be played" do
        game.set_match_count("6").should == 6
      end
    end
    
    describe "#role setting: human is the 'Code Maker'" do
      it "prompts human player for role" do
        #output.should_receive(:puts).with(message("role_prompt"))
        game.display.message("role_prompt")
        output.display.should == message("role_prompt")
      end
      
      it "gets the role input"
      
      it "validates the role input" do
        game.valid.role?("cm").should == true  
      end
      
      it "sets human player as 'Code Maker'" do
        user_input("cm")
        game.set_current_players
        game.code_maker.should == game.human_player    
      end
      
      it "sets ai player as 'Code Breaker" do
        user_input("cm")
        game.set_current_players
        game.code_breaker.should == game.ai_player
      end
      
      it "swaps human role from Code Maker to Code Breaker" do
        user_input("cm")
        game.set_current_players #human_player is code_maker
        game.set_current_players
        game.code_breaker.should == game.human_player  
      end
            
      it "displays role confirmation" do
        user_input("cm")
        game.set_current_players
        game.role_confirmation
        output.display.should == message("confirm_role", "Code Maker")
      end
    end
    
    describe "# launch Code maker" do
      it "sets_the_current_match" do
        game.matches.set_current
        game.matches.current_match.should == 1
      end
      
      it "displays current match" do
        game.set_match_count(6)
        game.matches.set_current
        game.display.message("current_match", game.matches.current_match, game.matches.match_count)
      end
      
      it "validates the code: valid" do
        game.code.valid.entry?("1111").should == true
      end
      
      it "validates the code: invalid" do
        game.code.valid.entry?("8888").should == false
      end
      
      it "generates code: ai player is the code maker" do
        user_input("cb")
        game.set_current_players
        guess_size = game.code.code_size
        min_digit = game.code.min_digit
        max_digit = game.code.max_digit
        game.code_maker.set_code_definitions(guess_size, min_digit, max_digit)
        code = game.code_maker.generate_code
        game.code.valid.entry?(code).should == true
      end
      
      it "prompts for code: human player is the code maker" do
        game.display.message("code_prompt")
        output.display.should == message("code_prompt")
      end
      
      it "gets the code from human_player"
      
      it "sets the code" do
        game.set_code("1111")
        game.code.code.should == "1111"  
      end
    end
      
    describe "#code breaker: ai" do
      it "sets the code definitions" do
        user_input("cm")
        game.set_current_players
        guess_size = game.code.code_size
        min_digit = game.code.min_digit
        max_digit = game.code.max_digit
        game.code_breaker.set_code_definitions(guess_size, min_digit, max_digit)
        game.ai_player.guess_size.should == 4  
      end
      
      it "displays the code to be broken: human is code maker" do
        game.display.code_grid("2346")
        output.display.should == code_grid("2346") 
      end
        
      it "guesses: ai player is the code breaker: 1 guess" do
        user_input("cm")
        code = game.set_code("5544")
        code_size = game.code.code_size
        min_digit = game.code.min_digit
        max_digit = game.code.max_digit
        game.set_current_players
        game.code_breaker.set_code_definitions(code_size, min_digit, max_digit)
        guess = game.code_breaker.generate_guess
        game.code_breaker.set_guess(guess, code)
        game.ai_player.guesses.size.should == 1
      end
      
        
      it "compares the ai player's last guess to the code: no match" do
        role = "cm"
        guess = "1111"
        code = "2222"
        stage_guess(role, guess, code)
        game.ai_player.guesses.last.should == "xxxx"
      end
      
      it "guesses until end of match: ai player is the code breaker" do
        user_input("cm")
        game.set_current_players
        code = game.set_code("1342")
        game.code_breaker.set_code_definitions(4,1,6)
        game.code_breaker.exhaust_guesses(code)
        game.code_breaker.guesses.size.should > 0
      end      
        
      it "displays all guesses" do
        role = "cm"
        guess = "1111"
        code = "1212"
        stage_guess(role, guess, code)
        game.display.guesses(game.code_breaker.guesses)
        output.display.should == guesses(game.code_breaker.guesses)
      end
      
      it "displays 6 guesses" do
        guesses = ["1111", "2222", "1212", "3434", "5621", "6161"]
        game.display.guesses(guesses)
        output.display.should ==  guesses(guesses)
      end
      
      it "checks that all guesses have been made: false" do
        user_input("cm")
        game.set_current_players
        guesses = ["1111","2222","3333","4444"]
        game.code_breaker.guesses = guesses
        game.code_breaker.valid.all_guesses_made?(guesses).should == false
      end

      it "checks that all guesses have been made: true" do
        user_input("cm")
        game.set_current_players
        guesses = ["1111","2222","3333","4444","5555","6666"]
        game.code_breaker.valid.all_guesses_made?(guesses).should == true
      end
      
      it "checks that all matches have been played: false" do
        current_match = 5
        match_count = 6
        game.matches.valid.all_matches_played?(current_match, match_count).should == false
      end

      it "checks that all matches have been played: true" do
        current_match = 6
        match_count = 6
        game.matches.valid.all_matches_played?(current_match, match_count).should == true
      end
            
      it "alerts ai is the winner: human loses" do
        user_input("cm")
        game.set_current_players
        game.set_code("2323")
        guesses = ["x3xx", "23xx", "232x", "2323"]
        game.code_breaker.guesses = guesses
        game.match_end_alert
        output.display.should == message("lose")
      end
      
      it "updates the current match" do
        game.matches.current_match = 1
        game.update_current_match.should == 2  
      end
      
      it "updates the code_breaker's stats: win" do 
        user_input("cm") 
        game.set_current_players
        game.set_code("2222")
        game.code_breaker.guesses = ["1111", "2222"]
        game.code_breaker.wins = 2
        game.update_player_stats
        game.ai_player.wins.should == 3
      end

      it "updates the code_breaker's stats: loss" do
        user_input("cm")
        game.set_current_players
        game.set_code"6666"
        game.code_breaker.losses = 2
        game.code_breaker.guesses = [1,2,3,4,5,6]
        game.update_player_stats
        game.ai_player.losses.should == 3
      end
      
      it "displays winner message" do
        game.display.message("win")
        output.display.should == message("win")
      end
      
      it "displays loser message" do
        game.display.message("lose")
        output.display.should == message("lose")
      end
      
      it "advances the game"
        #simulate setup
        #simultate code_maker
        #simulate code_breaker
        #game.match.current_match.should == 2
      
      it "ends the game: displays message"   do
        game.display.message("game over")
        output.display.should == message("game over")
      end

    end
    
    describe "#code breaker: human" do
      it "prompts for the first guess" do
        game.display.message("guess_prompt")
        output.display.should == message("guess_prompt")
      end
      
      it "gets the guess" do
        user_input("1111")
        game.get_human_guess.should == "1111"
      end
      
      it "validates the guess: valid" do
        user_input("cb")
        game.set_current_players
        game.code_breaker.guesses = ["1122"]
        guess = game.code_breaker.guesses.last
        game.code.valid.entry?(guess).should == true
      end
      
      it "validates the guess: invalid" do
        user_input("cb")
        game.set_current_players
        game.code_breaker.guesses = ["7788"]
        guess = game.code_breaker.guesses.last
        game.code.valid.entry?(guess).should == false
      end
      
      it "saves the guess: zero match" do
        user_input("cb")
        game.set_current_players
        code = game.set_code("6634")
        guess = "3345"
        game.code_breaker.set_guess(guess, code)
        game.code_breaker.guesses.last.should == "xxxx"          
      end
      
      it "saves the guess: 1 match" do
        user_input("cb")
        game.set_current_players
        code = game.set_code("6634")
        guess = "6345"
        game.code_breaker.set_guess(guess, code)
        game.code_breaker.guesses.last.should == "6xxx"          
      end
      
      it "saves the guess: 2 matches" do
        user_input("cb")
        game.set_current_players
        code = game.set_code("6634")
        guess = "6344"
        game.code_breaker.set_guess(guess, code)
        game.code_breaker.guesses.last.should == "6xx4"          
      end
      
      it "saves the guess: 3 matches" do
        user_input("cb")
        game.set_current_players
        code = game.set_code("6634")
        guess = "6334"
        game.code_breaker.set_guess(guess, code)
        game.code_breaker.guesses.last.should == "6x34"          
      end
      
      it "saves the guess: all match" do
        user_input("cb")
        game.set_current_players
        code = game.set_code("6634")
        guess = "6634"
        game.code_breaker.set_guess(guess, code)
        game.code_breaker.guesses.last.should == "6634"          
      end
      
      it "displays last guess" do
        user_input("cb")
        game.set_current_players
        code = game.set_code("5231")
        guesses = ["5431", "4562", "2234"]
        
        guesses.each do |x|
          game.code_breaker.set_guess(x, code)  
        end
        
        guess = game.code_breaker.guesses.last
        count = game.code_breaker.guesses.size
        game.display.last_guess(guess, count).should == last_guess(guess, count)
      end
      
      it "checks game status: code breaker wins"
      it "checks game status: code breaker loses"
      it "updates games stats"
      it "displays winner message"
      it "displays loser message"
      it "advances the game"
      it "ends the game: displays message"
    end
  end
end