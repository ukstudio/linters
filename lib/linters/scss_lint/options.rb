require "linters/base/options"
require "linters/scss_lint/tokenizer"

module Linters
  module ScssLint
    class Options < Linters::Base::Options
      def command(filename)
        "scss-lint #{filename}"
      end

      def config_filename
        ".scss-lint.yml"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content(content)
        config(content).to_yaml
      end

      private

      def config(content)
        Config.new(content: content, default_config_path: "config/scss.yml")
      end
    end
  end
end
