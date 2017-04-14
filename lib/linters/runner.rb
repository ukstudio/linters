require "linters/config"
require "linters/source_file"
require "linters/noop_file"
require "linters/lint"
require "linters/tokenizer"
require "jobs/completed_file_review_job"
require "jobs/report_invalid_config_job"

module Linters
  class Runner
    def self.call(*args)
      new(*args).call
    end

    # The attributes are passed from the job and contain the following:
    # - config
    # - content
    # - filename
    # - commit_sha (pass-through)
    # - linter_name (pass-through)
    # - patch (pass-through)
    # - pull_request_number (pass-through)
    def initialize(linter_options:, attributes:)
      @attributes = attributes
      @linter_options = linter_options
    end

    def call
      output = Lint.call(
        command: linter_options.command(filename),
        config_file: config_file,
        source_file: source_file,
      )
      errors = linter_options.tokenizer.errors(output)

      if errors.empty?
        violations = linter_options.tokenizer.violations(output)
        complete_file_review(violations)
      else
        Resque.enqueue(
          ReportInvalidConfigJob,
          pull_request_number: attributes.fetch("pull_request_number"),
          commit_sha: attributes.fetch("commit_sha"),
          linter_name: attributes.fetch("linter_name"),
          message: errors.first,
        )
      end
    end

    private

    attr_reader :attributes, :linter_options

    def source_file
      SourceFile.new(filename, attributes.fetch("content"))
    end

    def config_file
      if config_content
        SourceFile.new(
          linter_options.config_filename,
          config_content,
        )
      else
        NoopFile.new
      end
    end

    def complete_file_review(violations)
      Resque.enqueue(
        CompletedFileReviewJob,
        commit_sha: attributes.fetch("commit_sha"),
        filename: filename,
        linter_name: attributes.fetch("linter_name"),
        patch: attributes.fetch("patch"),
        pull_request_number: attributes.fetch("pull_request_number"),
        violations: violations,
      )
    end

    def filename
      attributes.fetch("filename")
    end

    def config_content
      linter_options.config_content(attributes.fetch("config"))
    end
  end
end
