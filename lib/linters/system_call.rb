require "open3"

module Linters
  class SystemCall
    def initialize(command:, directory:)
      @command = command
      @directory = directory
    end

    def execute
      output, status = Open3.capture2e(command, chdir: directory)

      if status.success?
        output
      else
        raise NonZeroExitStatusError.new("Command: '#{command}'", output)
      end
    end

    private

    attr_reader :command, :directory

    class NonZeroExitStatusError < StandardError
      attr_reader :output

      def initialize(message, output)
        super(message)
        @output = output
      end
    end
  end
end
