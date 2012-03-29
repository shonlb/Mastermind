require 'spec_helper'
require 'input'

# class IO
  # def gets
    # # blocks
  # end
# end

class FakeInput
  attr_writer :string
  
  def gets
    @string
  end
end

describe Input do
  it "gets user input" do
    fake_input = FakeInput.new
    string = "hello world"
    fake_input.string = string
    input = Input.new(fake_input)
    input.user_entry.chomp.should == string
  end
end

# class Game
  # def initialize
    # @input = Input.new(STDIN)
  # end
#   
  # def get_player
    # player = @input.user_entry
    # #player = gets
    # #player = Kernel.gets = STDIN.gets = $stdin.gets
#     
    # STDIN.gets
    # fake_input.gets
  # end
#end
