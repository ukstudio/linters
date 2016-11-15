require "resque"
require "linters/runner"
require "linters/sass_lint/options"

class SassLintReviewJob
  @queue = :sass_lint_review

  def self.perform(attributes)
    Linters::Runner.call(
      linter_options: Linters::SassLint::Options.new,
      attributes: attributes,
    )
  end
end
