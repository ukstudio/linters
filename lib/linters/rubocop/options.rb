require "linters/rubocop/tokenizer"

module Linters
  module Rubocop
    class Options
      def command(_filename)
        "rubocop"
      end

      def config_filename
        ".rubocop.yml"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content(content)
        config(content).to_yaml
      end

      private

      def config(content)
        Config.new(content: content, default_config_path: "config/rubocop.yml")
      end
    end
  end
end
