require "linters/base/tokenizer"

module Linters
  module Tslint
    class Tokenizer < Base::Tokenizer
      VIOLATION_REGEX = /\A
        (?<path>.+)\[
        (?<line_number>\d+),\s
        (?<column_number>\d+)\]:\s+
        (?<message>.+)\n?
      \z/x

      def violations(text)
        Linters::Tokenizer.new(text, VIOLATION_REGEX).violations
      end
    end
  end
end
