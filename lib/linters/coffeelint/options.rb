require "linters/coffeelint/tokenizer"

module Linters
  module Coffeelint
    class Options
      def command(filename)
        path = File.join(File.dirname(__FILE__), "../../..")
        cmd = "/node_modules/coffeelint/bin/coffeelint #{filename}"
        File.join(path, cmd)
      end

      def config_filename
        "coffeelint.json"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content(content)
        config(content).to_json
      end

      private

      def config(content)
        Config.new(
          content: content,
          default_config_path: "config/coffeelint.json",
        )
      end
    end
  end
end
