module Linters
  module ScssLint
    class Tokenizer
      VIOLATION_REGEX = /\A
        (?<path>.+):
        (?<line_number>\d+):
        (?<column_number>\d+)\s+
        \[(?<violation_level>\w)\]\s+
        (?<rule_name>[\w\s]+):\s+
        (?<message>.+)
        \n?
      \z/x

      def parse(text)
        Linters::Tokenizer.new(text, VIOLATION_REGEX).parse
      end
    end
  end
end
