require "resque"
require "linters/runner"
require "linters/haml_lint/options"

class HamlReviewJob
  @queue = :haml_review

  def self.perform(attributes)
    Linters::Runner.call(
      linter_options: Linters::HamlLint::Options.new,
      attributes: attributes,
    )
  end
end
