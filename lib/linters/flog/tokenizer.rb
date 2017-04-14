require "linters/base/tokenizer"

module Linters
  module Flog
    class Tokenizer < Base::Tokenizer
      MIN_COMPLEXITY_THRESHOLD = 25
      VIOLATION_REGEX = /\A
        \s*
        (?<score>\d+.\d+):\s
        (?<method>.+\#\w+)
        (?<file>.+):
        (?<line_number>\d+)
        \n?
      \z/x

      def violations(text)
        text.split("\n").map { |line| parse_violation(line) }.compact
      end

      private

      def parse_violation(line)
        matches = VIOLATION_REGEX.match(line)

        if matches && (matches[:score] || 0).to_i >= MIN_COMPLEXITY_THRESHOLD
          {
            line: matches[:line_number].to_i,
            message: "#{matches[:method]} is a complex method",
          }
        end
      end
    end
  end
end
