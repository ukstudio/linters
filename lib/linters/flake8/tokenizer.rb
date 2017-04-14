require "linters/base/tokenizer"

module Linters
  module Flake8
    class Tokenizer < Base::Tokenizer
      VIOLATION_REGEX = /\A
        (?<path>.+):
        (?<line_number>\d+):
        (?<column_number>\d+):\s+
        (?<violation_number>[\d,\w]+)\s+
        (?<message>.+)
        \n?
      \z/x

      def violations(text)
        Linters::Tokenizer.new(text, VIOLATION_REGEX).violations
      end
    end
  end
end
