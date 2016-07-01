require "linters/jshint/tokenizer"

module Linters
  module Jshint
    class Options
      def command(filename)
        path = File.join(File.dirname(__FILE__), "../../..")
        cmd = "/node_modules/jshint/bin/jshint #{filename}"
        File.join(path, cmd)
      end

      def config_filename
        ".jshintrc"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content(content)
        config(content).to_json
      end

      private

      def config(content)
        Config.new(content: content, default_config_path: "config/jshintrc")
      end
    end
  end
end
