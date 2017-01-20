require "linters/base/options"
require "linters/jshint/tokenizer"

module Linters
  module Jshint
    class Options < Linters::Base::Options
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
        if JSON.parse(content).any?
          content
        end
      end
    end
  end
end
