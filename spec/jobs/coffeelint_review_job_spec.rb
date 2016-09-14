require "jobs/coffeelint_review_job"

RSpec.describe CoffeelintReviewJob do
  include LintersHelper

  context "when file with .coffee extention contains violations" do
    it "reports violations" do
      expect_violations_in_file(
        content: content,
        filename: "foo/test.coffee",
        violations: [
          {
            line: 1,
            message: "Class name should be UpperCamelCased. class name: myObj.",
          },
          {
            line: 2,
            message: "Empty parameter list is forbidden.",
          },
        ],
      )
    end
  end

  context "when custom configuraton is provided" do
    it "respects the custom configuration" do
      config = <<~JSON
        {
          "no_empty_param_list": {
            "level": "ignore"
          }
        }
      JSON

      expect_violations_in_file(
        config: config,
        content: content,
        filename: "foo/test.js",
        violations: [
          {
            line: 1,
            message: "Class name should be UpperCamelCased. class name: myObj.",
          },
        ],
      )
    end
  end

  def content
    <<~EOS
      class myObj
        foo = () ->
          'hello world'
    EOS
  end
end
