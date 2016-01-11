require "resque"
require "scss_lint"
require "ext/scss_lint/config.rb"
require "config_options"
require "jobs/completed_file_review_job"
require "jobs/report_invalid_config_job"

class Review
  COMMIT_SHA = "commit_sha".freeze
  CONFIG = "config".freeze
  CONTENT = "content".freeze
  DEFAULT_VIOLATIONS = [].freeze
  FILENAME = "filename".freeze
  LINTER_NAME = "scss".freeze
  PATCH = "patch".freeze
  PULL_REQUEST_NUMBER = "pull_request_number".freeze

  def self.run(attributes)
    new(attributes).run
  end

  def initialize(attributes)
    @attributes = attributes
    @config_options = ConfigOptions.new(attributes[CONFIG])
  end

  def run
    if config_options.valid?
      violations = review_file
      complete_file_review(violations)
    else
      report_invalid_config
    end
  end

  private

  attr_reader :config_options, :attributes

  def report_invalid_config
    Resque.enqueue(
      ReportInvalidConfigJob,
      pull_request_number: attributes.fetch(PULL_REQUEST_NUMBER),
      commit_sha: attributes.fetch(COMMIT_SHA),
      linter_name: LINTER_NAME,
    )
  end

  def review_file
    scss_lint_config = SCSSLint::Config.new(config_options.to_hash)
    filename = attributes.fetch(FILENAME)

    if !scss_lint_config.excluded_file?(filename)
      scss_lint_runner = SCSSLint::Runner.new(scss_lint_config)

      create_tempfile do |tempfile|
        scss_lint_runner.run([file: tempfile, path: filename])
      end

      scss_lint_runner.lints.map do |lint|
        { line: lint.location.line, message: lint.description }
      end
    else
      DEFAULT_VIOLATIONS
    end
  end

  def create_tempfile
    filename = File.basename(attributes.fetch(FILENAME))
    Tempfile.create(filename) do |file|
      file.write(attributes.fetch(CONTENT))
      file.rewind

      yield(file)
    end
  end

  def complete_file_review(violations)
    Resque.enqueue(
      CompletedFileReviewJob,
      filename: attributes.fetch(FILENAME),
      commit_sha: attributes.fetch(COMMIT_SHA),
      pull_request_number: attributes.fetch(PULL_REQUEST_NUMBER),
      patch: attributes.fetch(PATCH),
      violations: violations,
    )
  end
end
