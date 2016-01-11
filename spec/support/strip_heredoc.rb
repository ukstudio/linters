# Stolen from ActiveSupport,
# `activesupport/lib/active_support/core_ext/string/strip.rb`
class String
  def strip_heredoc
    indent = scan(/^[ \t]*(?=\S)/).min.size
    gsub(/^[ \t]{#{indent}}/, "")
  end
end
