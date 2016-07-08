module Linters
  module Jshint
    class Tokenizer
      VIOLATION_REGEX = /\A
        (?<path>.+)\D+
        (?<line_number>\d+)\D+
        (?<column_number>\d+),\s+
        (?<message>.+)
        \n?
      \z/x

      def parse(text)
        Linters::Tokenizer.new(text, VIOLATION_REGEX).parse
      end
    end
  end
end
