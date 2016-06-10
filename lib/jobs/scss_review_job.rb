require "resque"
require "linters/runner"
require "linters/scss_lint/options"

class ScssReviewJob
  @queue = :scss_review

  def self.perform(attributes)
    Linters::Runner.call(
      linter_options: Linters::ScssLint::Options.new,
      attributes: attributes,
    )
  end
end
