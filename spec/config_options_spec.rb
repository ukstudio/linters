require "spec_helper"
require "config_options"

describe ConfigOptions do
  describe "#valid?" do
    context "when given a valid config" do
      it "returns true" do
        config_options = ConfigOptions.new("")

        expect(config_options.valid?).to eq true
      end
    end

    context "when given an invalid config" do
      it "returns false" do
        config_options = ConfigOptions.new("--- !ruby/object:FooBar {}")

        expect(config_options.valid?).to eq false
      end
    end
  end

  describe "#to_hash" do
    it "returns merged config options as a hash" do
      config_options = ConfigOptions.new(<<-CONFIG.strip_heredoc)
        linters:
          BangFormat:
            enabled: false
      CONFIG

      options_hash = config_options.to_hash

      expect(options_hash.to_hash["linters"]["BangFormat"]["enabled"]).to eq false
    end
  end
end
