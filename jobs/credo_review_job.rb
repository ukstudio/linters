require "resque"
require "linters/runner"
require "linters/credo/options"

class CredoReviewJob
  @queue = :credo_review

  def self.perform(attributes)
    Linters::Runner.call(
      linter_options: Linters::Credo::Options.new,
      attributes: attributes,
    )
  end
end
