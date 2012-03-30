module Mastermind
  class Code
    attr_accessor :code
    attr_reader :min_digit, :max_digit, :code_size, :valid
    
    def initialize
      @code = ""
      @min_digit = 1
      @max_digit = 6
      @code_size = 4
      @valid = Validate.new(@code_size, @min_digit, @max_digit)
    end
  end
end