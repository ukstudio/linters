require "resque"
require "linters/runner"
require "linters/jshint/options"

class JshintReviewJob
  @queue = :jshint_review

  def self.perform(attributes)
    Linters::Runner.call(
      linter_options: Linters::Jshint::Options.new,
      attributes: attributes,
    )
  end
end
