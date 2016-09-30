module Linters
  module Coffeelint
    class Tokenizer
      VIOLATION_REGEX = /\A
        .*\#
        (?<line_number>\d+):
        (?<parse_error_details>.+:\d+:)?
        \s
        (?<message>.+)
        \n?
      \z/x

      def parse(text)
        Linters::Tokenizer.new(text, VIOLATION_REGEX).parse
      end
    end
  end
end
