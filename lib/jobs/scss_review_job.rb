require "tempfile"
require "resque"
require "scss_lint"

require "ext/scss_lint/config"
require "jobs/completed_file_review_job"
require "config_options"

class ScssReviewJob
  @queue = :scss_review

  def self.perform(attributes)
    # filename
    # commit_sha
    # pull_request_number (pass-through)
    # patch (pass-through)
    # content
    # config

    config_options = ConfigOptions.new(attributes["config"])
    scss_lint_config = SCSSLint::Config.new(config_options.to_hash)
    filename = attributes.fetch("filename")
    violations = []

    unless scss_lint_config.excluded_file?(filename)
      scss_lint_runner = SCSSLint::Runner.new(scss_lint_config)

      tempfile_from(attributes) do |tempfile|
        scss_lint_runner.run([tempfile])
      end

      violations = scss_lint_runner.lints.map do |lint|
        { line: lint.location.line, message: lint.description }
      end
    end

    Resque.enqueue(
      CompletedFileReviewJob,
      filename: filename,
      commit_sha: attributes.fetch("commit_sha"),
      pull_request_number: attributes.fetch("pull_request_number"),
      patch: attributes.fetch("patch"),
      violations: violations
    )
  end

  def self.tempfile_from(attributes)
    filename = File.basename(attributes.fetch("filename"))
    Tempfile.create(filename) do |file|
      file.write(attributes.fetch("content"))
      file.rewind

      yield(file)
    end
  end
end
