require "linters/base/options"
require "linters/eslint/tokenizer"

module Linters
  module Eslint
    class Options < Linters::Base::Options
      def command(filename)
        path = File.join(File.dirname(__FILE__), "../../..")
        cmd = "/node_modules/eslint/bin/eslint.js #{filename}"
        File.join(path, cmd)
      end

      def config_filename
        ".eslintrc"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content(content)
        config(content).to_yaml
      end

      private

      def config(content)
        Config.new(content: content, default_config_path: "config/eslintrc")
      end
    end
  end
end
