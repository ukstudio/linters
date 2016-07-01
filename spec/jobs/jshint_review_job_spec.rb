require "jobs/jshint_review_job"

RSpec.describe JshintReviewJob do
  include LintersHelper

  context "when file with .js extention contains violations" do
    it "reports violations" do
      expect_violations_in_file(
        content: content,
        filename: "foo/test.js",
        violations: [
          {
            line: 3,
            message: "'hello' is defined but never used.",
          },
        ],
      )
    end
  end

  context "when custom configuraton is provided" do
    it "respects the custom configuration" do
      config = <<~JSON
        {
          "unused": false
        }
      JSON

      expect_violations_in_file(
        config: config,
        content: content,
        filename: "foo/test.js",
        violations: [],
      )
    end
  end

  def content
    <<~JS
      (function () {
        'use strict';
        function hello() { }
      }());
    JS
  end
end
