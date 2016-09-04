require "jobs/rubocop_review_job"

RSpec.describe RubocopReviewJob do
  include LintersHelper

  context "when file contains violations" do
    it "reports violations" do
      content = <<~EOS
        # frozen_string_literal: true
        def foo(bar:, baz:)
          bar
        end
      EOS

      expect_violations_in_file(
        content: content,
        filename: "foo/test.rb",
        violations: [
          {
            line: 2,
            message: "Unused method argument - baz.",
          },
        ],
      )
    end
  end

  context "when directory is excluded" do
    it "reports no violations" do
      config = <<~YAML
        AllCops:
          Exclude:
            - "foo/test.rb"
      YAML

      expect_violations_in_file(
        config: config,
        content: "def yo;   42 end",
        filename: "foo/*",
        violations: [],
      )
    end
  end

  context "when sytnax is invalid" do
    it "reports an error as violation" do
      expect_violations_in_file(
        content: "def yo 42 end",
        filename: "foo/test.rb",
        violations: [
          {
            line: 1,
            message: "unexpected token tINTEGER",
          },
        ],
      )
    end
  end
end
