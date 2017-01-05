require "linters/tokenizer"
require "linters/credo/tokenizer"

describe Linters::Credo::Tokenizer do
  describe "#parse" do
    it "parses line numbers when columns provided" do
      tokenizer = Linters::Credo::Tokenizer.new

      parsed = tokenizer.parse <<~OUTPUT
        test_elixir.ex:5:11: R: Modules should have a @moduledoc tag.
      OUTPUT

      expect(parsed).to eq(
        [{ line: 5, message: "Modules should have a @moduledoc tag." }],
      )
    end

    it "parses line numbers when columns not provided" do
      tokenizer = Linters::Credo::Tokenizer.new

      parsed = tokenizer.parse <<~OUTPUT
        test_elixir.ex:5: R: Modules should have a @moduledoc tag.
      OUTPUT

      expect(parsed).to eq(
        [{ line: 5, message: "Modules should have a @moduledoc tag." }],
      )
    end
  end
end
