require "spec_helper"
require "jobs/scss_review_job"

describe ScssReviewJob do
  describe ".perform" do
    it "enqueues completed file review job with violations" do
      allow(Resque).to receive(:enqueue)

      ScssReviewJob.perform(
        "filename" => "test.scss",
        "commit_sha" => "123abc",
        "pull_request_number" => "123",
        "patch" => "test",
        "content" => "$color: #aaa\n",
      )

      expect(Resque).to have_received(:enqueue).with(
        CompletedFileReviewJob,
        filename: "test.scss",
        commit_sha: "123abc",
        pull_request_number: "123",
        patch: "test",
        violations: [
          { line: 1, message: expected_violation_message },
        ]
      )
    end

    context "linter fails" do
      it "does not enqueue a completed file review job" do
        linter = instance_double(Linters::ScssLint::Linter)
        allow(linter).to receive(:violations).and_raise(RuntimeError)
        allow(Linters::ScssLint::Linter).to receive(:new).and_return(linter)
        allow(Resque).to receive(:enqueue)

        expect do
          ScssReviewJob.perform(
            "filename" => "test.scss",
            "commit_sha" => "123abc",
            "pull_request_number" => "123",
            "patch" => "test",
            "content" => "",
          )
        end.to raise_error RuntimeError
        expect(Resque).not_to have_received(:enqueue)
      end
    end

    def expected_violation_message
      "Declaration should be terminated by a semicolon"
    end
  end
end
