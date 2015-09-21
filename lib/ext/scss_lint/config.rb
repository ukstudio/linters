# Patch SCSSLint::Config to expand file_path
# to the same directory as the config file,
# which is a Tempfile itself.
module SCSSLint
  class Config
    def excluded_file?(file_path)
      @options.fetch("exclude", []).any? do |exclusion_glob|
        File.fnmatch(exclusion_glob, file_path)
      end
    end
  end
end
