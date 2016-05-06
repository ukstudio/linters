require "spec_helper"
require "config_options"
require "haml_lint/runner"
require "source_file"

describe HamlLint::Runner do
  describe "#violations_for" do
    it "executes proper command to get violations" do
      config = ConfigOptions.new("", "haml.yml")
      file = SourceFile.new("file.html.haml", "let x = 'Hello'")
      system_call = SystemCall.new
      allow(system_call).to receive(:call).and_return("")
      runner = HamlLint::Runner.new(config, system_call: system_call)

      runner.violations_for(file)

      expect(system_call).to have_received(:call).with("haml-lint .")
    end

    it "returns all violations" do
      config = ConfigOptions.new("", "haml.yml")
      file = SourceFile.new("bar.html.haml", file_content)
      runner = HamlLint::Runner.new(config)

      violations = runner.violations_for(file)

      expect(violations.size).to eq(2)
    end

    context "when directory is excluded" do
      it "returns no violations" do
        config = ConfigOptions.new("exclude: foo/*", "haml.yml")
        file = SourceFile.new("foo/bar.html.haml", file_content)
        runner = HamlLint::Runner.new(config)

        violations = runner.violations_for(file)

        expect(violations.size).to eq(0)
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
