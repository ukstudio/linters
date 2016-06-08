require "jobs/scss_review_job"

RSpec.describe ScssReviewJob do
  it_behaves_like(
    "a linter",
    content: "$color: #aaa\n",
    filename: "test.scss",
    violations: [
      { line: 1, message: "Declaration should be terminated by a semicolon" }
    ],
  )
end
