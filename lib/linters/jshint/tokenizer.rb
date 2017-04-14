require "linters/base/tokenizer"

module Linters
  module Jshint
    class Tokenizer < Base::Tokenizer
      VIOLATION_REGEX = /\A
        (?<path>.+)\D+
        (?<line_number>\d+)\D+
        (?<column_number>\d+),\s+
        (?<message>.+)
        \n?
      \z/x

      def violations(text)
        Linters::Tokenizer.new(text, VIOLATION_REGEX).violations
      end
    end
  end
end
