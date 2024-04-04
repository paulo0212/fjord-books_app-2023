# frozen_string_literal: true

module ReportsHelper
  def convert_url_to_link(text)
    uri_regexp = URI::DEFAULT_PARSER.make_regexp(%w[http https])
    text.gsub(uri_regexp) { %(<a href='#{::Regexp.last_match(0)}' target='_blank'>#{::Regexp.last_match(0)}</a>) }
  end
end
