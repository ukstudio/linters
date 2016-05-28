module Linters
  module HamlLint
    class Tokenizer
      VIOLATION_LEVEL_ERROR = "E".freeze

      VIOLATION_REGEX = /\A
        (?<path>.+):
        (?<line_number>\d+)\s+
        \[(?<violation_level>\w)\]\s+
        ((?<rule_name>[\w\s]+):\s+)?
        (?<message>.+)
        \n?
      \z/x

      def parse(text)
        text.split("\n").map { |line| tokenize(line) }.compact
      end

      private

      def tokenize(line)
        matches = VIOLATION_REGEX.match(line)

        if matches
          violation_level = matches[:violation_level]
          line_number = matches[:line_number].to_i
          {
            line: line_number + line_offset(violation_level),
            message: matches[:message],
          }
        end
      end

      def line_offset(violation_level)
        if account_for_zero_indexing?(violation_level)
          1
        else
          0
        end
      end

      def account_for_zero_indexing?(violation_level)
        violation_level == VIOLATION_LEVEL_ERROR
      end
    end
  end
end
