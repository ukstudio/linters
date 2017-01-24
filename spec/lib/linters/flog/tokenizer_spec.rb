require "linters/flog/tokenizer"

module Linters
  module Flog
    RSpec.describe Tokenizer do
      describe "#parse" do
        it "parses line numbers when score is high enough" do
          input = "  28.2: BadFlog#some_method              lib/bad_flog.rb:2\n"
          expected_message = "BadFlog#some_method is a complex method"
          tokenizer = Tokenizer.new

          parsed = tokenizer.parse(input)

          expect(parsed).to eq([{ line: 2, message: expected_message }])
        end
      end
    end
  end
end
