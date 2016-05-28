require "resque"

require "linters/haml_lint/linter"
require "runner"

class HamlReviewJob
  @queue = :haml_review

  def self.perform(attributes)
    Runner.call(
      attributes: attributes,
      linter_class: Linters::HamlLint::Linter,
      config_filename: "haml.yml",
    )
  end
end
