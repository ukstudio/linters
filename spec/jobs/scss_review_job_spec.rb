require "spec_helper"
require "jobs/scss_review_job"

describe ScssReviewJob do
  describe ".perform" do
    it "enqueues completed file review job with violations" do
      config = ConfigOptions.new("", "scss.yml")
      runner = ScssLint::Runner.new(config)
      allow(Resque).to receive(:enqueue)
      allow(ScssLint::Runner).to receive(:new).and_return(runner)
      allow(runner).
        to receive(:execute_linter).and_return(linter_response)

      ScssReviewJob.perform(
        "filename" => "test.scss",
        "commit_sha" => "123abc",
        "pull_request_number" => "123",
        "patch" => "test",
        "content" => "",
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

    context "runner fails" do
      it "does not enqueue a completed file review job" do
        runner = instance_double(ScssLint::Runner)
        allow(runner).to receive(:violations_for).and_raise(RuntimeError)
        allow(ScssLint::Runner).to receive(:new).and_return(runner)
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
      "Color `#aaaaaa` should be written as `#aaa`"
    end

    def linter_response
      "test.scss:1 [W] HexLength: Color `#aaaaaa` should be written as `#aaa`"
    end
  end
end
