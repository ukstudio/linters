require "jobs/linters_job"

RSpec.describe LintersJob, "for remark-lint" do
  include LintersHelper

  context "when file with .js extention contains violations" do
    it "reports violations" do
      expect_violations_in_file(
        content: content,
        filename: "foo/test.md",
        linter_name: "remark",
        violations: [
          {
            line: 1,
            message: "Incorrect list-item indent: add 2 spaces",
          },
          {
            line: 3,
            message: "Found reference to undefined definition",
          },
        ],
      )
    end
  end

  context "when custom configuraton is provided" do
    it "respects the custom configuration" do
      config = <<~JSON
        {
          "plugins": {
            "lint": {
              "no-shortcut-reference-link": true,
              "list-item-bullet-indent": true
            }
          }
        }
      JSON

      expect_violations_in_file(
        config: config,
        content: content,
        filename: "foo/test.md",
        linter_name: "remark",
        violations: [],
      )
    end
  end

  def content
    <<~MD
      * Hello

      [World][]
    MD
  end
end
