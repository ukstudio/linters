require "jobs/remark_review_job"

RSpec.describe RemarkReviewJob do
  include LintersHelper

  context "when file with .js extention contains violations" do
    it "reports violations" do
      expect_violations_in_file(
        content: content,
        filename: "foo/test.md",
        violations: [],
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
