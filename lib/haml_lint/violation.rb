module HamlLint
  class Violation
    VIOLATION_LEVEL_ERROR = "E".freeze

    VIOLATION_REGEX = /\A
      (?<path>.+):
      (?<line_number>\d+)\s+
      \[(?<violation_level>\w)\]\s+
      ((?<rule_name>[\w\s]+):\s+)?
      (?<message>.+)
      \n?
    \z/x

    def self.parsable?(string)
      !!(string =~ VIOLATION_REGEX)
    end

    def initialize(violation_string)
      @violation = violation_string
    end

    def to_hash
      {
        line: line_number,
        message: message,
      }
    end

    def line_number
      if account_for_zero_indexing?
        parts[:line_number].to_i + 1
      else
        parts[:line_number].to_i
      end
    end

    def message
      parts[:message]
    end

    private

    def parts
      matches = VIOLATION_REGEX.match(violation)

      if matches.nil?
        raise ViolationParseError, %(Violation: "#{violation}")
      end

      {
        line_number: matches[:line_number],
        message: matches[:message],
        violation_level: matches[:violation_level],
      }
    end

    def account_for_zero_indexing?
      parts[:violation_level] == VIOLATION_LEVEL_ERROR
    end

    attr_reader :violation
  end

  class ViolationParseError < StandardError
  end
end
