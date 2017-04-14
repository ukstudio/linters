module Linters
  class Tokenizer
    def initialize(text, regex)
      @text = text
      @regex = regex
    end

    def violations
      text.split("\n").map { |line| parse_violation(line, regex) }.compact
    end

    private

    attr_reader :text, :regex

    def parse_violation(line, regex)
      matches = regex.match(line)

      if matches
        {
          line: matches[:line_number].to_i,
          message: matches[:message],
        }
      end
    end
  end
end
