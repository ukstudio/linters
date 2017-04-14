require "linters/base/tokenizer"

module Linters
  module Reek
    # Reek Tokenizer class will parse and return a hash containing the line of
    # the infraction, and a message with a link to see further information
    class Tokenizer < Base::Tokenizer
      VIOLATION_REGEX = /\A
        (?<path>.+):
        (?<line_number>\d+):\s
        (?<message>.*)
        \n?
      \z/x

      def violations(text)
        parser_results = Linters::Tokenizer.new(
          text,
          VIOLATION_REGEX,
        ).violations

        parser_results.map do |result|
          result[:message].
            gsub!("]", ").").
            gsub!(" [", ". [More info](")

          result
        end
      end
    end
  end
end
