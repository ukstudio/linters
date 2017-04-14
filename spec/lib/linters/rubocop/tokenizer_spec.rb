# frozen_string_literal: true
require "linters/tokenizer"
require "linters/rubocop/tokenizer"

describe Linters::Rubocop::Tokenizer do
  describe "#errors" do
    it "parses error message" do
      tokenizer = Linters::Rubocop::Tokenizer.new

      errors = tokenizer.errors <<~OUTPUT
        Error: The `Style/SpaceBeforeModifierKeyword` cop has been removed. Please use `Style/SpaceAroundKeyword` instead.
      OUTPUT

      expect(errors).to eq(
        ["The `Style/SpaceBeforeModifierKeyword` cop has been removed. Please use `Style/SpaceAroundKeyword` instead."],
      )
    end
  end
end
