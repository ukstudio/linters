require "linters/base/tokenizer"

module Linters
  module Coffeelint
    class Tokenizer < Base::Tokenizer
      VIOLATION_REGEX = /\A
        .*\#
        (?<line_number>\d+):
        (?<parse_error_details>.+:\d+:)?
        \s
        (?<message>.+)
        \n?
      \z/x

      def violations(text)
        Linters::Tokenizer.new(text, VIOLATION_REGEX).violations
      end
    end
  end
end
