require "resque"
require "linters/runner"
require "linters/rubocop/options"

class RubocopReviewJob
  @queue = :rubocop_review

  def self.perform(attributes)
    Linters::Runner.call(
      linter_options: Linters::Rubocop::Options.new,
      attributes: attributes,
    )
  end
end
