module Linters
  module Credo
    class Tokenizer
      VIOLATION_REGEX = /\A
        (?<file_name>.+):
        (?<line_number>\d+):\s+
        (?<violation_level>\w+):\s+
        (?<message>.+)
        \n?
      \z/x

      def parse(text)
        Linters::Tokenizer.new(text, VIOLATION_REGEX).parse
      end
    end
  end
end
