require "resque"
require "linters/runner"
require "linters/coffeelint/options"

class CoffeelintReviewJob
  @queue = :coffeelint_review

  def self.perform(attributes)
    Linters::Runner.call(
      linter_options: Linters::Coffeelint::Options.new,
      attributes: attributes,
    )
  end
end
