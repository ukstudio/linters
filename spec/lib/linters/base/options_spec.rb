require "linters/base/options"

RSpec.describe Linters::Base::Options do
  describe "#command" do
    it "raises a NotImplementedError" do
      options = Class.new(Linters::Base::Options).new
      exception = NotImplementedError
      message = 'implement #command in your Options class'

      expect { options.command("a.rb") }.to raise_exception(exception, message)
    end
  end
end
