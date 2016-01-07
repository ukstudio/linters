require "spec_helper"
require "jobs/scss_review_job"

describe ScssReviewJob do
  describe ".perform" do
    context "when the configuration file is invalid" do
      it "reports the configuration file as such to Hound proper" do
        allow(Resque).to receive(:enqueue)
        attributes = {
          "filename" => "app/assets/stylsheets/test.scss",
          "commit_sha" => "123abc",
          "pull_request_number" => "123",
          "patch" => "test",
          "content" => ".a { display: 'none'; }\n",
          "config" => "--- !ruby/object:Foo {}",
        }

        ScssReviewJob.perform(attributes)

        expect(Resque).to have_received(:enqueue).with(
          ReportInvalidConfigJob,
          pull_request_number: "123",
          commit_sha: "123abc",
          linter_name: ScssReviewJob::LINTER_NAME,
        )
        expect(Resque).not_to have_received(:enqueue).
          with(CompletedFileReviewJob, anything)
      end
    end

    context "when double quotes are preferred by default" do
      it "enqueues review job with violations" do
        allow(Resque).to receive("enqueue")

        ScssReviewJob.perform(
          "filename" => "app/assets/stylsheets/test.scss",
          "commit_sha" => "123abc",
          "pull_request_number" => "123",
          "patch" => "test",
          "content" => ".a { display: 'none'; }\n"
        )

        expect(Resque).to have_received("enqueue").with(
          CompletedFileReviewJob,
          filename: "app/assets/stylsheets/test.scss",
          commit_sha: "123abc",
          pull_request_number: "123",
          patch: "test",
          violations: [
            { line: 1, message: "Prefer double-quoted strings" }
          ]
        )
      end
    end

    context "when string quotes rule is disabled" do
      it "enqueues review job without violations" do
        allow(Resque).to receive("enqueue")

        ScssReviewJob.perform(
          "filename" => "app/assets/stylsheets/test.scss",
          "commit_sha" => "123abc",
          "pull_request_number" => "123",
          "patch" => "test",
          "content" => ".a { display: 'none'; }\n",
          "config" => <<-CONFIG
linters:
  StringQuotes:
    enabled: false
    style: double_quotes
          CONFIG
        )

        expect(Resque).to have_received("enqueue").with(
          CompletedFileReviewJob,
          filename: "app/assets/stylsheets/test.scss",
          commit_sha: "123abc",
          pull_request_number: "123",
          patch: "test",
          violations: []
        )
      end
    end

    context "when file with violations is excluded as an Array" do
      it "enqueues review job without violations" do
        allow(Resque).to receive("enqueue")

        ScssReviewJob.perform(
          "filename" => "app/assets/stylesheets/test.scss",
          "commit_sha" => "123abc",
          "pull_request_number" => "123",
          "patch" => "test",
          "content" => ".a { display: 'none'; }\n",
          "config" => <<-CONFIG
exclude:
  - "app/assets/stylesheets/test.scss"
          CONFIG
        )

        expect(Resque).to have_received("enqueue").with(
          CompletedFileReviewJob,
          filename: "app/assets/stylesheets/test.scss",
          commit_sha: "123abc",
          pull_request_number: "123",
          patch: "test",
          violations: []
        )
      end
    end

    context "when file with violations is excluded as a String" do
      it "enqueues review job without violations" do
        allow(Resque).to receive("enqueue")

        ScssReviewJob.perform(
          "filename" => "app/assets/stylsheets/test.scss",
          "commit_sha" => "123abc",
          "pull_request_number" => "123",
          "patch" => "test",
          "content" => ".a { display: 'none'; }\n",
          "config" => <<-CONFIG
exclude:
  "app/assets/*"
          CONFIG
        )

        expect(Resque).to have_received("enqueue").with(
          CompletedFileReviewJob,
          filename: "app/assets/stylsheets/test.scss",
          commit_sha: "123abc",
          pull_request_number: "123",
          patch: "test",
          violations: []
        )
      end
    end
  end
end
