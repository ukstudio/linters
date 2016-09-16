require "linters/coffeelint/tokenizer"

module Linters
  module Coffeelint
    class Options
      def command(filename)
        "#{replace_erb_tags(filename)} && #{coffeelint(filename)}"
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

      def replace_erb_tags(filename)
        "sed -i.bak 's/<%.*%>/123/g' #{filename}"
      end

      def coffeelint(filename)
        path = File.join(File.dirname(__FILE__), "../../..")
        cmd = "/node_modules/coffeelint/bin/coffeelint #{filename}"
        File.join(path, cmd)
      end
    end
  end
end
