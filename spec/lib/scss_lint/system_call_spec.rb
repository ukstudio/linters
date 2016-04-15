require "spec_helper"
require "scss_lint/system_call"

describe ScssLint::SystemCall do
  context "running valid command" do
    it "captures stdout" do
      system = ScssLint::SystemCall.new

      output = system.call("printf 'Hello World!'")

      expect(output).to eq("Hello World!")
    end

    it "captures stderr" do
      system = ScssLint::SystemCall.new

      output = system.call("printf 'Hello World!' 1>&2")

      expect(output).to eq("Hello World!")
    end

    it "captures and concats stdout and stderr" do
      system = ScssLint::SystemCall.new

      command = "printf 'Hello Stdout!' && printf 'Hello Stderr!' 1>&2"
      output = system.call(command)

      expect(output).to eq("Hello Stdout!Hello Stderr!")
    end
  end

  context "running an invalid command" do
    it "raises an error" do
      system = ScssLint::SystemCall.new

      expect { system.call("printf") }.
        to raise_error(
          ScssLint::SystemCall::NonZeroExitStatusError,
          "Command: 'printf'",
        )
    end

    it "stores the command's output on the error" do
      system = ScssLint::SystemCall.new

      expect { system.call("printf") }.to raise_error do |error|
        expect(error.output).
          to match(/(usage: printf format)|(printf: missing operand)/)
      end
    end
  end
end
