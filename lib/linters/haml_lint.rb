require "haml_lint/violation"
require "system_call"

module Linters
  class HamlLint
    def initialize(config, system_call: SystemCall.new)
      @config_file = SourceFile.new(".haml-lint.yml", config.to_yaml)
      @system_call = system_call
    end

    def violations_for(file)
      violation_strings(file).map do |violation_string|
        Haml::Violation.new(violation_string).to_hash
      end
    end

    private

    attr_reader :config_file, :system_call

    def violation_strings(file)
      result = execute_linter(file).split("\n")
      result.select { |string| message_parsable?(string) }
    end

    def execute_linter(file)
      SourceFile.in_tmpdir(file, config_file) do |dir|
        run_linter_on_system(dir)
      end
    end

    def run_linter_on_system(directory)
      Dir.chdir(directory) do
        system_call.call("haml-lint .")
      end
    rescue SystemCall::NonZeroExitStatusError => e
      e.output
    end

    def message_parsable?(string)
      Haml::Violation.parsable?(string)
    end
  end
end
