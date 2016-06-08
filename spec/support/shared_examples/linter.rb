RSpec.shared_examples "a linter" do |args|
  it "enqueues a job with violations" do
    attributes = {
      "filename" => args.fetch(:filename),
      "content" => args.fetch(:content),
      "commit_sha" => "anything",
      "patch" => "",
      "pull_request_number" => "1",
    }
    allow(Resque).to receive(:enqueue)

    described_class.perform(attributes)

    expect(Resque).to have_received(:enqueue).with(
      CompletedFileReviewJob,
      commit_sha: attributes["commit_sha"],
      filename: attributes["filename"],
      patch: attributes["patch"],
      pull_request_number: attributes["pull_request_number"],
      violations: args.fetch(:violations),
    )
  end
end
