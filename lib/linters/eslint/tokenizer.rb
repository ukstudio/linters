require "linters/base/tokenizer"

module Linters
  module Eslint
    class Tokenizer < Base::Tokenizer
      VIOLATION_REGEX = /\A
        (?<line_number>.+):
        (?<column_number>\d+)\s+
        (?<violation_level>\w+)\s+
        (?<message>.+)
        \n?
      \z/x

      def violations(text)
        Linters::Tokenizer.new(text, VIOLATION_REGEX).violations
      end
    end
  end
end
