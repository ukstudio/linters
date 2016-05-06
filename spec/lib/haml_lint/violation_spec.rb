require "spec_helper"
require "haml_lint/violation"

describe HamlLint::Violation do
  describe ".parsable?" do
    context "given a valid violation" do
      it "should parse full violation" do
        parsable = HamlLint::Violation.parsable?(violation_string)

        expect(parsable).to eq(true)
      end
    end

    context "given an invalid violation" do
      it "should not be able to parse" do
        parsable = HamlLint::Violation.parsable?("Invalid string")

        expect(parsable).to eq(false)
      end
    end
  end

  describe "#line_number" do
    it "returns line number" do
      violation = HamlLint::Violation.new(violation_string(line_number: 1))

      expect(violation.line_number).to eq(1)
    end

    it "raises with an invalid string" do
      violation = HamlLint::Violation.new("invalid string")

      expect { violation.line_number }.
        to raise_error(
          HamlLint::ViolationParseError,
          /Violation: "invalid string"/,
        )
    end
  end

  describe "#message" do
    it "returns the message" do
      message = "Trailing Whitespace Violation: It should not have whitespace."
      violation = HamlLint::Violation.new(violation_string(message: message))

      expect(violation.message).to eq(message)
    end

    it "raises with an invalid string" do
      violation = HamlLint::Violation.new("invalid string")

      expect { violation.message }.
        to raise_error(
          HamlLint::ViolationParseError,
          /Violation: "invalid string"/,
        )
    end
  end

  def violation_string(line_number: 1, message: default_violation_message)
    "tmp/test.haml.html:#{line_number} [W] Inconsistent indentation: #{message}"
  end

  def default_violation_message
    "8 spaces used for indentation, but the rest of the document legit."
  end
end
