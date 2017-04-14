module Linters
  module Base
    # Base Options class for all linters
    # @abstract
    class Options
      # Linter command that will run against a file
      # @param _filename [String] relative path to the file being checked
      # @return [String] cli command to run
      def command(_filename)
        not_implemented!(__method__)
      end

      # Filename for configuration file which linter expects by default.
      # @return [String] path and filename of the config file the linter wants
      def config_filename
        not_implemented!(__method__)
      end

      # Object to find violations in linter output, returning hash with line
      # numbers and messages of the violations
      # @return [#violations, #errors] a Tokenizer object implementing `#violations` and `#errors`
      def tokenizer
        not_implemented!(__method__)
      end

      # Returns content of linter's configuration file.  If the configuration
      # needs merging -- the default config needs to be combined with repo's
      # config -- then that work should happen here.
      # @param _content [String] contents of a config file
      # @return [Sring, nil] the contents of the config file or nil
      def config_content(_content)
        not_implemented!(__method__)
      end

      private

      def not_implemented!(method)
        raise NotImplementedError, "implement ##{method} in your Options class"
      end
    end
  end
end
