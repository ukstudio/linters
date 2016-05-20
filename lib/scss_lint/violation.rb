module ScssLint
  class Violation
    VIOLATION_REGEX = /\A
      (?<path>.+):
      (?<line_number>\d+)\s+
      \[(?<violation_level>\w)\]\s+
      (?<rule_name>[\w\s]+):\s+
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
      parts[:line_number].to_i
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
      }
    end

    attr_reader :violation
  end

  class ViolationParseError < StandardError
  end
end
