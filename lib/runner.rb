require "config_options"
require "linters/source_file"
require "jobs/completed_file_review_job"

class Runner
  def self.call(*args)
    new(*args).call
  end

  # The attributes are passed from the job and contain the following:
  # - filename
  # - content
  # - config
  # - pull_request_number (pass-through)
  # - commit_sha (pass-through)
  # - patch (pass-through)
  def initialize(attributes:, linter_class:, default_config_filename:)
    @attributes = attributes
    @linter_class = linter_class
    @default_config_filename = default_config_filename
  end

  def call
    violations = linter.violations(file)
    complete_file_review(violations)
  end

  private

  attr_reader :attributes, :linter_class, :default_config_filename

  def linter
    linter_class.new(config)
  end

  def config
    ConfigOptions.new(attributes["config"], default_config_filename)
  end

  def file
    Linters::SourceFile.new(
      attributes.fetch("filename"),
      attributes.fetch("content"),
    )
  end

  def complete_file_review(violations)
    Resque.enqueue(
      CompletedFileReviewJob,
      commit_sha: attributes.fetch("commit_sha"),
      filename: attributes.fetch("filename"),
      patch: attributes.fetch("patch"),
      pull_request_number: attributes.fetch("pull_request_number"),
      violations: violations,
    )
  end
end
