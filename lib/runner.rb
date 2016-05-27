require "config_options"
require "source_file"
require "jobs/completed_file_review_job"

class Runner
  # This job receives the following arguments
  # - filename
  # - content
  # - config
  # - pull_request_number (pass-through)
  # - commit_sha (pass-through)
  # - patch (pass-through)
  def initialize(attributes:, linter_class:, config_filename:)
    @attributes = attributes
    @linter_class = linter_class
    @config_filename = config_filename
  end

  def call
    violations = linter.violations_for(file)
    complete_file_review(violations)
  end

  private

  attr_reader :attributes, :linter_class, :config_filename

  def linter
    linter_class.new(config)
  end

  def config
    ConfigOptions.new(attributes["config"], config_filename)
  end

  def file
    SourceFile.new(
      attributes.fetch("filename"),
      attributes.fetch("content"),
    )
  end

  def complete_file_review(violations)
    Resque.enqueue(
      CompletedFileReviewJob,
      commit_sha: attributes.fetch("commit_sha"),
      filename: file.path,
      patch: attributes.fetch("patch"),
      pull_request_number: attributes.fetch("pull_request_number"),
      violations: violations,
    )
  end
end
