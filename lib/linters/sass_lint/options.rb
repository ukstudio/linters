require "linters/sass_lint/tokenizer"

module Linters
  module SassLint
    class Options
      def command(filename)
        path = File.join(File.dirname(__FILE__), "../../..")
        cmd = "/node_modules/sass-lint/bin/sass-lint.js #{filename}"
        File.join(path, cmd)
      end

      def config_filename
        ".sass-lint.yml"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content(content)
        config(content).to_yaml
      end

      private

      def config(content)
        Config.new(
          content: content,
          default_config_path: "config/sass-lint.yml",
        )
      end
    end
  end
end
