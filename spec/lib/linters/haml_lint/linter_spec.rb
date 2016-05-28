require "spec_helper"
require "config_options"
require "linters/haml_lint/linter"

describe Linters::HamlLint::Linter do
  describe "#violations" do
    it "returns all violations" do
      config = ConfigOptions.new("", "haml.yml")
      file = Linters::SourceFile.new("bar.html.haml", file_content)
      linter = Linters::HamlLint::Linter.new(config)

      violations = linter.violations(file)

      expect(violations.size).to eq(2)
    end

    context "when directory is excluded" do
      it "returns no violations" do
        config = ConfigOptions.new("exclude: foo/*", "haml.yml")
        file = Linters::SourceFile.new("foo/bar.html.haml", file_content)
        linter = Linters::HamlLint::Linter.new(config)

        violations = linter.violations(file)

        expect(violations.size).to eq(0)
      end
    end

    context "when the HAML is invalid" do
      it "returns error as violation" do
        invalid_content = <<~HAML
          .main
            %div
                %span
        HAML
        config = ConfigOptions.new("", "haml.yml")
        file = Linters::SourceFile.new("bar.html.haml", invalid_content)
        linter = Linters::HamlLint::Linter.new(config)

        violations = linter.violations(file)

        expect(violations.size).to eq(1)
        expect(violations.first[:line]).to eq 3
      end
    end
  end

  def file_content
    <<~HAML
      %div.hello
      %div.hello
    HAML
  end
end
