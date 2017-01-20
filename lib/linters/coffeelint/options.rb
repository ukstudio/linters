require "linters/base/options"
require "linters/coffeelint/tokenizer"

module Linters
  module Coffeelint
    class Options < Linters::Base::Options
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
        if JSON.parse(content).any?
          content
        end
      end

      private

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
