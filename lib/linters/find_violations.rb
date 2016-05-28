require "linters/system_call"

module Linters
  class FindViolations
    def self.call(*args)
      new(*args).call
    end

    def initialize(command:, config_file:, source_file:, violation_tokenizer:)
      @command = command
      @config_file = config_file
      @source_file = source_file
      @tokenizer = violation_tokenizer
    end

    def call
      tokenizer.parse(execute_linter)
    end

    private

    attr_reader :command, :config_file, :source_file, :tokenizer

    def execute_linter
      Dir.mktmpdir do |dir|
        source_file.write_to_dir(dir)
        config_file.write_to_dir(dir)
        run_linter_on_system(dir)
      end
    end

    def run_linter_on_system(directory)
      system_call(directory).execute
    rescue SystemCall::NonZeroExitStatusError => e
      e.output
    end

    def system_call(directory)
      SystemCall.new(command: command, directory: directory)
    end
  end
end
