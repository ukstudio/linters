require "linters/base/options"
require "linters/haml_lint/tokenizer"

module Linters
  module HamlLint
    class Options < Linters::Base::Options
      def command(filename)
        "haml-lint #{filename}"
      end

      def config_filename
        ".haml-lint.yml"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content(content)
        config(content).to_yaml
      end

      private

      def config(content)
        Config.new(content: content, default_config_path: "config/haml.yml")
      end
    end
  end
end
