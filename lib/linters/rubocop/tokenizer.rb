require "linters/base/tokenizer"

module Linters
  module Rubocop
    class Tokenizer < Base::Tokenizer
      VIOLATION_REGEX = /\A
        (?<path>.+):
        (?<line_number>\d+):
        (?<column_number>\d+):\s+
        (?<violation_level>\w):\s+
        (?<message>.+)
        \n?
      \z/x

      ERROR_REGEX = /\AError: (?<error>.*)\z/

      def violations(text)
        text.split("\n").map { |line| parse_violation(line) }.compact
      end

      def errors(text)
        text.split("\n").map { |line| parse_error(line) }.compact
      end

      private

      def parse_violation(line)
        matches = VIOLATION_REGEX.match(line)

        if matches
          line_number = matches[:line_number].to_i
          {
            line: line_number,
            message: matches[:message],
          }
        end
      end

      def parse_error(line)
        matches = ERROR_REGEX.match(line)

        if matches
          matches[:error]
        end
      end
    end
  end
end
