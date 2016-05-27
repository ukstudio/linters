require "resque"

require "linters/haml_lint"
require "runner"

class HamlReviewJob
  @queue = :haml_review

  def self.perform(attributes)
    Runner.new(
      attributes: attributes,
      linter_class: Linters::HamlLint,
      config_filename: "haml.yml",
    ).call
  end
end
