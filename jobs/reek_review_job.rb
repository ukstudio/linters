require "resque"
require "linters/runner"
require "linters/reek/options"

class ReekReviewJob
  @queue = :reek_review

  def self.perform(attributes)
    Linters::Runner.call(
      linter_options: Linters::Reek::Options.new,
      attributes: attributes,
    )
  end
end
