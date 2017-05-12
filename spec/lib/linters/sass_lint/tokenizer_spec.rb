require "linters/sass_lint/tokenizer"
require "linters/tokenizer"

RSpec.describe Linters::SassLint::Tokenizer do
  describe "#parse" do
    it "parses line numbers when columns are provided" do
      input = <<~SCSS
        22:1  warning  Space expected between blocks  empty-line-between-blocks
      SCSS
      expected = "Space expected between blocks  empty-line-between-blocks"
      tokenizer = Linters::SassLint::Tokenizer.new

      parsed_message = tokenizer.parse(input)

      expect(parsed_message).to eq([{ line: 22, message: expected }])
    end
  end
end
