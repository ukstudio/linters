require "linters/base/tokenizer"

# frozen_string_literal: true
module Linters
  module Stylelint
    class Tokenizer < Base::Tokenizer
      VIOLATION_REGEX = /
        (?<line_number>.+):
        (?<column_number>\d+)\s+
        (?<violation_level>.)\s+
        (?<message>.+\S)
      /x

      def violations(text)
        Linters::Tokenizer.new(text, VIOLATION_REGEX).violations
      end
    end
  end
end
