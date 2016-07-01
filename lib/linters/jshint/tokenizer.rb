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
        text.split("\n").map { |line| tokenize(line) }.compact
      end

      private

      def tokenize(line)
        matches = VIOLATION_REGEX.match(line)

        if matches
          {
            line: matches[:line_number].to_i,
            message: matches[:message],
          }
        end
      end
    end
  end
end
