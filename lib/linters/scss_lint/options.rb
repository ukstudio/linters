require "linters/scss_lint/tokenizer"

module Linters
  module ScssLint
    class Options
      def command
        "scss-lint"
      end

      def config_filename
        ".scss-lint.yml"
      end

      def default_config_path
        "config/scss.yml"
      end

      def tokenizer
        Tokenizer.new
      end
    end
  end
end
