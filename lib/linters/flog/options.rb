require "linters/flog/tokenizer"

module Linters
  module Flog
    class Options
      def command(filename)
        "flog --all --continue --quiet #{filename}"
      end

      def config_content(config)
        config
      end

      def config_filename
        ".flog"
      end

      def tokenizer
        Tokenizer.new
      end
    end
  end
end
