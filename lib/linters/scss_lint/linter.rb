require "linters/find_violations"
require "linters/scss_lint/tokenizer"
require "linters/source_file"

module Linters
  module ScssLint
    class Linter
      def initialize(config)
        @config = config
      end

      def violations(file)
        FindViolations.call(
          command: "scss-lint",
          config_file: config_file,
          source_file: file,
          violation_tokenizer: Tokenizer.new,
        )
      end

      private

      attr_reader :config

      def config_file
        SourceFile.new(".scss-lint.yml", config.to_yaml)
      end
    end
  end
end
