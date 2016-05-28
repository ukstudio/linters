require "spec_helper"
require "linters/system_call"

describe Linters::SystemCall do
  context "running valid command" do
    it "captures stdout" do
      system = Linters::SystemCall.new(
        command: "printf 'Hello World!'",
        directory: ".",
      )

      output = system.execute

      expect(output).to eq("Hello World!")
    end

    it "captures stderr" do
      system = Linters::SystemCall.new(
        command: "printf 'Hello World!' 1>&2",
        directory: ".",
      )

      output = system.execute

      expect(output).to eq("Hello World!")
    end

    it "captures and concats stdout and stderr" do
      system = Linters::SystemCall.new(
        command: "printf 'Hello Stdout!' && printf 'Hello Stderr!' 1>&2",
        directory: ".",
      )

      output = system.execute

      expect(output).to eq("Hello Stdout!Hello Stderr!")
    end
  end

  context "running an invalid command" do
    it "raises an error" do
      system = Linters::SystemCall.new(
        command: "printf",
        directory: ".",
      )

      expect { system.execute }.
        to raise_error(
          Linters::SystemCall::NonZeroExitStatusError,
          "Command: 'printf'",
        )
    end

    it "stores the command's output on the error" do
      system = Linters::SystemCall.new(
        command: "printf",
        directory: ".",
      )

      expect { system.execute }.to raise_error do |error|
        expect(error.output).
          to match(/(usage: printf format)|(printf: missing operand)/)
      end
    end
  end
end
