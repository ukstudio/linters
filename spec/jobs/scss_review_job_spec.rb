require "spec_helper"
require "jobs/scss_review_job"

describe ScssReviewJob do
  describe ".perform" do
    it "calls ScssReview" do
      allow(Review).to receive(:run)
      attributes = {
        "filename" => "app/assets/stylsheets/test.scss",
        "commit_sha" => "123abc",
        "pull_request_number" => "123",
        "patch" => "test",
        "content" => ".a { display: 'none'; }\n",
        "config" => "--- !ruby/object:Foo {}",
      }

      ScssReviewJob.perform(attributes)

      expect(Review).to have_received(:run).with(attributes)
    end
  end
end
