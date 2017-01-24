module Linters
  module Flog
    class Tokenizer
      MIN_COMPLEXITY_THRESHOLD = 25
      VIOLATION_REGEX = /\A
        \s*
        (?<score>\d+.\d+):\s
        (?<method>.+\#\w+)
        (?<file>.+):
        (?<line_number>\d+)
        \n?
      \z/x

      def parse(text)
        text.split("\n").map { |line| tokenize(line) }.compact
      end

      private

      def tokenize(line)
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
