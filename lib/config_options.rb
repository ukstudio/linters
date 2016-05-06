require "yaml"

class ConfigOptions
  def initialize(config, default_file_name)
    @custom_options = YAML.load(config.to_s) || {}
    @default_config_path = File.join("config", default_file_name)
  end

  def to_yaml
    to_hash.to_yaml
  end

  def to_hash
    default_options.merge(custom_options)
  end

  private

  attr_reader :custom_options

  def default_options
    @default_config ||= YAML.load_file(@default_config_path)
  end
end
