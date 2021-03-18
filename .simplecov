# frozen_string_literal: true

require "simplecov_json_formatter"
require "simplecov-sublime"

CI_FORMATTERS = [
  SimpleCov::Formatter::SimpleFormatter,
  SimpleCov::Formatter::JSONFormatter,
].freeze

LOCAL_FORMATTERS = [
  SimpleCov::Formatter::JSONFormatter,
  SimpleCov::Formatter::SublimeFormatter,
  SimpleCov::Formatter::HTMLFormatter,
].freeze

# SimpleCov.command_name "RSpec"
# SimpleCov.refuse_coverage_drop
SimpleCov.formatters = [
  SimpleCov::Formatter::JSONFormatter,
  SimpleCov::Formatter::SublimeFormatter,
]

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/bin/"
  add_filter "/gemfiles/"

  add_group "Redis Script", "lib/redis_script"

  enable_coverage :branch
  primary_coverage :branch

  if ENV["CI"]
    formatter SimpleCov::Formatter::MultiFormatter.new(CI_FORMATTERS)
  else
    formatter SimpleCov::Formatter::MultiFormatter.new(LOCAL_FORMATTERS)

    refuse_coverage_drop
    minimum_coverage line: 90, branch: 80
    minimum_coverage_by_file line: 90, branch: 80
  end

  track_files "**/*.rb"
end
