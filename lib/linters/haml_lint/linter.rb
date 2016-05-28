require "linters/find_violations"
require "linters/haml_lint/tokenizer"
require "linters/source_file"

module Linters
  module HamlLint
    class Linter
      def initialize(config)
        @config = config
      end

      def violations(file)
        FindViolations.call(
          command: "haml-lint .",
          config_file: config_file,
          source_file: file,
          violation_tokenizer: Tokenizer.new,
        )
      end

      private

      attr_reader :config

      def config_file
        SourceFile.new(".haml-lint.yml", config.to_yaml)
      end
    end
  end
end
