require "spec_helper"
require "config_options"
require "scss_lint/runner"
require "source_file"

describe ScssLint::Runner do
  describe "#violations_for" do
    it "executes proper command to get violations" do
      config = ConfigOptions.new("")
      file = SourceFile.new("file.scss", "let x = 'Hello'")
      system_call = SystemCall.new
      allow(system_call).to receive(:call).and_return("")
      runner = ScssLint::Runner.new(config, system_call: system_call)

      runner.violations_for(file)

      expect(system_call).to have_received(:call).with("scss-lint")
    end

    it "returns all violations" do
      config = ConfigOptions.new("")
      file = SourceFile.new("foo/bar.scss", file_content)
      runner = ScssLint::Runner.new(config)

      violations = runner.violations_for(file)

      expect(violations.size).to eq(2)
    end

    context "when directory is excluded" do
      it "returns no violations" do
        config = ConfigOptions.new("exclude: foo/*")
        file = SourceFile.new("foo/bar.scss", file_content)
        runner = ScssLint::Runner.new(config)

        violations = runner.violations_for(file)

        expect(violations.size).to eq(0)
      end
    end
  end

  def file_content
    <<~SCSS
      .myStyle {
        color: #aaaaaa;
        font-style: italic;
      }
    SCSS
  end
end
