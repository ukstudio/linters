require "spec_helper"
require "config_options"
require "source_file"
require "linters/haml_lint"

describe Linters::HamlLint do
  describe "#violations_for" do
    it "executes proper command to get violations" do
      config = ConfigOptions.new("", "haml.yml")
      file = SourceFile.new("file.html.haml", "let x = 'Hello'")
      system_call = SystemCall.new
      allow(system_call).to receive(:call).and_return("")
      linter = Linters::HamlLint.new(config, system_call: system_call)

      linter.violations_for(file)

      expect(system_call).to have_received(:call).with("haml-lint .")
    end

    it "returns all violations" do
      config = ConfigOptions.new("", "haml.yml")
      file = SourceFile.new("bar.html.haml", file_content)
      linter = Linters::HamlLint.new(config)

      violations = linter.violations_for(file)

      expect(violations.size).to eq(2)
    end

    context "when directory is excluded" do
      it "returns no violations" do
        config = ConfigOptions.new("exclude: foo/*", "haml.yml")
        file = SourceFile.new("foo/bar.html.haml", file_content)
        linter = Linters::HamlLint.new(config)

        violations = linter.violations_for(file)

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
        file = SourceFile.new("bar.html.haml", invalid_content)
        linter = Linters::HamlLint.new(config)

        violations = linter.violations_for(file)

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
