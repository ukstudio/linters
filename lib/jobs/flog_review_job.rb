require "resque"
require "linters/runner"
require "linters/flog/options"

class FlogReviewJob
  @queue = :flog_review

  def self.perform(attributes)
    Linters::Runner.call(
      attributes: attributes,
      linter_options: Linters::Flog::Options.new,
    )
  end
end
