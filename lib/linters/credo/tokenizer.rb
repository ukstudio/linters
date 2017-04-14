require "linters/base/tokenizer"

module Linters
  module Credo
    class Tokenizer < Base::Tokenizer
      VIOLATION_REGEX = /\A
        (?<file_name>[^:]+):
        (?<line_number>\d+):
        ((?<column_number>\d+):)?\s+
        (?<violation_level>\w+):\s+
        (?<message>.+)
        \n?
      \z/x

      def violations(text)
        Linters::Tokenizer.new(text, VIOLATION_REGEX).violations
      end
    end
  end
end
