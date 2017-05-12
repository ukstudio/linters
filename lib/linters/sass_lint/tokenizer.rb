module Linters
  module SassLint
    class Tokenizer
      VIOLATION_REGEX = /
        (?<line_number>.+):
        (?<column_number>\d+)\s+
        (?<violation_level>\w+)\s+
        (?<message>.+\S)
      /x

      def parse(text)
        Linters::Tokenizer.new(text, VIOLATION_REGEX).parse
      end
    end
  end
end
