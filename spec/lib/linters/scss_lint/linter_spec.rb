require "spec_helper"
require "config_options"
require "linters/scss_lint/linter"

describe Linters::ScssLint::Linter do
  describe "#violations" do
    it "returns all violations" do
      config = ConfigOptions.new("", "scss.yml")
      file = Linters::SourceFile.new("foo/bar.scss", file_content)
      linter = Linters::ScssLint::Linter.new(config)

      violations = linter.violations(file)

      expect(violations.size).to eq(2)
    end

    context "when directory is excluded" do
      it "returns no violations" do
        config = ConfigOptions.new("exclude: foo/*", "scss.yml")
        file = Linters::SourceFile.new("foo/bar.scss", file_content)
        linter = Linters::ScssLint::Linter.new(config)

        violations = linter.violations(file)

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
        file = Linters::SourceFile.new("bar.scss", invalid_content)
        linter = Linters::ScssLint::Linter.new(config)

        violations = linter.violations(file)

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
