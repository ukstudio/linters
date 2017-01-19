require "linters/tokenizer"
require "linters/reek/tokenizer"

describe Linters::Reek::Tokenizer do
  describe "#parse" do
    it "parses line numbers when columns provided" do
      input = "test.rb:9: ModuleName: LintersHelper has no descriptive comment"
      expected_message = "ModuleName: LintersHelper has no descriptive comment"
      tokenizer = Linters::Reek::Tokenizer.new

      parsed = tokenizer.parse(input)

      expect(parsed).to eq([{ line: 9, message: expected_message }])
    end
  end
end
