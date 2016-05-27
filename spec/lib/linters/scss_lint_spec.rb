require "spec_helper"
require "config_options"
require "source_file"
require "linters/scss_lint"

describe Linters::ScssLint do
  describe "#violations_for" do
    it "executes proper command to get violations" do
      config = ConfigOptions.new("", "scss.yml")
      file = SourceFile.new("file.scss", "let x = 'Hello'")
      system_call = SystemCall.new
      allow(system_call).to receive(:call).and_return("")
      linter = Linters::ScssLint.new(config, system_call: system_call)

      linter.violations_for(file)

      expect(system_call).to have_received(:call).with("scss-lint")
    end

    it "returns all violations" do
      config = ConfigOptions.new("", "scss.yml")
      file = SourceFile.new("foo/bar.scss", file_content)
      linter = Linters::ScssLint.new(config)

      violations = linter.violations_for(file)

      expect(violations.size).to eq(2)
    end

    context "when directory is excluded" do
      it "returns no violations" do
        config = ConfigOptions.new("exclude: foo/*", "scss.yml")
        file = SourceFile.new("foo/bar.scss", file_content)
        linter = Linters::ScssLint.new(config)

        violations = linter.violations_for(file)

        expect(violations.size).to eq(0)
      end
    end

    context "when the SCSS is invalid" do
      it "returns error as violation" do
        invalid_content = <<~SCSS
          .main {
            display: "none";
          {
        SCSS
        config = ConfigOptions.new("", "scss.yml")
        file = SourceFile.new("bar.scss", invalid_content)
        linter = Linters::ScssLint.new(config)

        violations = linter.violations_for(file)

        expect(violations.size).to eq(1)
        expect(violations.first[:line]).to eq 3
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
