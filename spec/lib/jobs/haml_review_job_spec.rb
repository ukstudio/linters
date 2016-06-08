require "jobs/haml_review_job"

RSpec.describe HamlReviewJob do
  it_behaves_like(
    "a linter",
    content: "%div\n  #main",
    filename: "test.haml",
    violations: [
      {
        line: 2,
        message: "Files should end with a trailing newline",
      }
    ],
  )
end
