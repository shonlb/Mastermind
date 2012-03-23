module Mastermind
  class Code
    attr_accessor :code
    attr_reader :min_digit, :max_digit, :code_size
    
    def initialize
      @code = ""
      @min_digit = 1
      @max_digit = 6
      @code_size = 4
    end
    
    def is_numeric?(check_value)
      !!Float(check_value) rescue false
    end
    
    def is_valid?(check)
      if check.size == @code_size
        check.split("").all? {|digit| is_numeric?(digit) && digit.to_i>= @min_digit && digit.to_i <= @max_digit }
      else
        false
      end
    end
    
    def set_code(entry)
      code = entry
    end
  end
end