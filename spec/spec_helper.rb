# frozen_string_literal: true

require "bundler/setup"

if RUBY_ENGINE == "ruby" && RUBY_VERSION >= "2.6" && RUBY_VERSION < "2.7"
  require "simplecov" unless %w[false 0].include?(ENV["COV"])

  begin
    require "pry"
  rescue LoadError
    puts "Pry unavailable"
  end
end

require "rspec"
require "brpoplpush/redis_script"

LOGLEVEL = ENV.fetch("LOGLEVEL") { "ERROR" }.upcase

Brpoplpush::RedisScript.configure do |config|
  config.logger.level     = Logger.const_get(LOGLEVEL)
  config.debug_lua        = %w[1 true].include?(ENV["DEBUG_LUA"])
  config.script_directory = Pathname.new(__FILE__).dirname.join("support", "lua")
end

Dir[File.join(File.dirname(__FILE__), "support", "**", "*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.example_status_persistence_file_path = ".rspec_status"
  config.filter_run :focus unless ENV["CI"]
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.warnings = false
  config.default_formatter = "doc" if config.files_to_run.one?
  config.order = :random

  Kernel.srand config.seed
end

RSpec::Support::ObjectFormatter.default_instance.max_formatted_output_length = 10_000

def capture(stream)
  begin
    stream = stream.to_s
    eval("$#{stream} = StringIO.new") # rubocop:disable Security/Eval, Style/EvalWithLocation
    yield
    result = eval("$#{stream}").string # rubocop:disable Security/Eval, Style/EvalWithLocation
  ensure
    eval("$#{stream} = #{stream.upcase}") # rubocop:disable Security/Eval, Style/EvalWithLocation
  end

  result
end
