require "tempfile"
require "resque"
require "scss_lint"

require "ext/scss_lint/config"
require "jobs/completed_file_review_job"
require "jobs/report_invalid_config_job"
require "config_options"

class ScssReviewJob
  LINTER_NAME = "scss"

  @queue = :scss_review

  def self.perform(attributes)
    # filename
    # commit_sha
    # pull_request_number (pass-through)
    # patch (pass-through)
    # content
    # config

    config_options = ConfigOptions.new(attributes["config"])

    if config_options.valid?
      review_file(config_options, attributes)
    else
      report_invalid_config(attributes)
    end
  end

  def self.review_file(config_options, attributes)
    scss_lint_config = SCSSLint::Config.new(config_options.to_hash)
    filename = attributes.fetch("filename")
    violations = []

    unless scss_lint_config.excluded_file?(filename)
      scss_lint_runner = SCSSLint::Runner.new(scss_lint_config)

      tempfile_from(attributes) do |tempfile|
        scss_lint_runner.run(
          [
            file: tempfile,
            path: attributes.fetch("filename"),
          ],
        )
      end

      violations = scss_lint_runner.lints.map do |lint|
        { line: lint.location.line, message: lint.description }
      end
    end

    complete_file_review(violations, attributes)
  end
  private_class_method :review_file

  def self.tempfile_from(attributes)
    filename = File.basename(attributes.fetch("filename"))
    Tempfile.create(filename) do |file|
      file.write(attributes.fetch("content"))
      file.rewind

      yield(file)
    end
  end
  private_class_method :tempfile_from

  def self.complete_file_review(violations, attributes)
    Resque.enqueue(
      CompletedFileReviewJob,
      filename: attributes.fetch("filename"),
      commit_sha: attributes.fetch("commit_sha"),
      pull_request_number: attributes.fetch("pull_request_number"),
      patch: attributes.fetch("patch"),
      violations: violations,
    )
  end
  private_class_method :complete_file_review

  def self.report_invalid_config(attributes)
    Resque.enqueue(
      ReportInvalidConfigJob,
      pull_request_number: attributes.fetch("pull_request_number"),
      commit_sha: attributes.fetch("commit_sha"),
      linter_name: LINTER_NAME,
    )
  end
  private_class_method :report_invalid_config
end
