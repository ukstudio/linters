module Linters
  class Tokenizer
    def initialize(text, regex)
      @text = text
      @regex = regex
    end

    def parse
      text.split("\n").map { |line| tokenize(line, regex) }.compact
    end

    private

    attr_reader :text, :regex

    def tokenize(line, regex)
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
