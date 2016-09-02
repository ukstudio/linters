require "linters/remark/tokenizer"

module Linters
  module Remark
    class Options
      def command(filename)
        path = File.join(File.dirname(__FILE__), "../../..")
        cmd = "/node_modules/remark-cli/cli.js -r .remarkrc #{filename}"
        File.join(path, cmd)
      end

      def config_filename
        ".remarkrc"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content(content)
        config(content).to_json
      end

      private

      def config(content)
        Config.new(content: content, default_config_path: "config/remarkrc")
      end
    end
  end
end
