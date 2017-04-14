module Linters
  module Base
    # Base Tokenizer class for all linters
    # @abstract
    class Tokenizer
      # Parses style violation line numbers and messages from linter response
      # @param _text [String] linter output
      # @return [Hash] violation line numbers and messages, ex. {line: 123, message: "Wat"}
      def violations(_text)
        not_implemented!(__method__)
      end

      # Parses linter error line numbers and messages from linter response
      # @param _text [String] linter output
      # @return [Array] linter error messages
      def errors(_text)
        []
      end

      private

      def not_implemented!(method)
        raise NotImplementedError, "implement ##{method} in your Tokenizer class"
      end
    end
  end
end
