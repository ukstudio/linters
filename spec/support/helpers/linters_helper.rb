module LintersHelper
  def expect_violations_in_file(content:, filename:, config: "{}", violations:)
    attributes = {
      "config" => config,
      "content" => content,
      "commit_sha" => "anything",
      "filename" => filename,
      "patch" => "",
      "linter_name" => "foo",
      "pull_request_number" => "1",
    }
    allow(Resque).to receive(:enqueue)

    described_class.perform(attributes)

    expect(Resque).to have_received(:enqueue).with(
      CompletedFileReviewJob,
      commit_sha: attributes["commit_sha"],
      filename: attributes["filename"],
      linter_name: attributes["linter_name"],
      patch: attributes["patch"],
      pull_request_number: attributes["pull_request_number"],
      violations: violations,
    )
  end
end
