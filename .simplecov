# frozen_string_literal: true

require "simplecov-sublime"

SimpleCov.command_name "RSpec"
# SimpleCov.refuse_coverage_drop
SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::SublimeFormatter,
]

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/bin/"
  add_filter "/gemfiles/"
end
