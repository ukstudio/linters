require "resque"
require "linters/runner"
require "linters/remark/options"

class RemarkReviewJob
  @queue = :remark_review

  def self.perform(attributes)
    Linters::Runner.call(
      linter_options: Linters::Remark::Options.new,
      attributes: attributes,
    )
  end
end
