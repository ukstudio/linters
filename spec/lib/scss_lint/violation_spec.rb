require "spec_helper"
require "scss_lint/violation"

describe ScssLint::Violation do
  describe ".parsable?" do
    context "given a valid violation" do
      it "should parse full violation" do
        parsable = ScssLint::Violation.parsable?(violation_string)

        expect(parsable).to eq(true)
      end
    end

    context "fiven a valid error" do
      it "parses the error" do
        parsable = ScssLint::Violation.parsable?(error_message)

        expect(parsable).to eq(true)
      end
    end

    context "given an invalid violation" do
      it "should not be able to parse" do
        parsable = ScssLint::Violation.parsable?("Invalid string")

        expect(parsable).to eq(false)
      end
    end
  end

  describe "#line_number" do
    context "when the message is a violation" do
      it "returns line number" do
        violation = ScssLint::Violation.new(violation_string(line_number: 1))

        expect(violation.line_number).to eq(1)
      end
    end

    context "when the message is an error" do
      it "returns the reported line number" do
        violation = ScssLint::Violation.new(error_message(line_number: 4))

        expect(violation.line_number).to eq(4)
      end
    end

    context "when the message is invalid" do
      it "raises with an invalid string" do
        violation = ScssLint::Violation.new("invalid string")

        expect { violation.line_number }.
          to raise_error(
            ScssLint::ViolationParseError,
            /Violation: "invalid string"/,
          )
      end
    end
  end

  describe "#message" do
    context "when the message is a violation" do
      it "returns the message" do
        message = "Trailing Whitespace Violation: It should not have whitespace"
        violation = ScssLint::Violation.new(violation_string(message: message))

        expect(violation.message).to eq(message)
      end
    end

    context "when the message is an error" do
      it "returns the message" do
        message = "You did it wrong"
        violation = ScssLint::Violation.new(error_message(message: message))

        expect(violation.message).to eq(message)
      end
    end

    context "when the message is invalid" do
      it "raises with an invalid string" do
        violation = ScssLint::Violation.new("invalid string")

        expect { violation.message }.
          to raise_error(
            ScssLint::ViolationParseError,
            /Violation: "invalid string"/,
          )
      end
    end
  end

  def violation_string(line_number: 1, message: default_violation_message)
    "tmp/test.scss:#{line_number} [W] SelectorFormat: #{message}"
  end

  def default_violation_message
    "Color `#aaaaaa` should be written as `#aaa`"
  end

  def error_message(line_number: 1, message: "Something went wrong")
    "file.scss:#{line_number} [E] Syntax Error: #{message}"
  end
end
