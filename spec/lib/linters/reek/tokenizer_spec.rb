require "linters/tokenizer"
require "linters/reek/tokenizer"

describe Linters::Reek::Tokenizer do
  describe "#parse" do
    it "parses line numbers when columns provided" do
      explanation_link = "https://github.com/troessner/reek/wiki.md"

      original_input = [
        "text.rb:9:",                  # file and line number
        "FakeReekModule:",             # Reek module which found infraction
        "Error [#{explanation_link}]", # link to wiki explaining infraction
      ].join(" ")

      expected_message = [
        "FakeReekModule:",                          # Reek module
        "Error. [More info](#{explanation_link}).", # link converted to markdown
      ].join(" ")

      tokenizer = Linters::Reek::Tokenizer.new
      parsed = tokenizer.parse(original_input)

      expect(parsed).to eq([{ line: 9, message: expected_message }])
    end
  end
end
