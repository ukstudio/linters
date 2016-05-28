require "resque"

require "linters/scss_lint/linter"
require "runner"

class ScssReviewJob
  @queue = :scss_review

  def self.perform(attributes)
    Runner.new(
      attributes: attributes,
      linter_class: Linters::ScssLint::Linter,
      default_config_filename: "scss.yml",
    ).call
  end
end
