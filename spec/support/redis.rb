# frozen_string_literal: true

RSpec.configure do |config|
  config.before do |_example|
    redis = Redis.new
    redis.script(:flush)
    redis.flushdb
  end

  config.after do
    redis = Redis.new
    redis.script(:flush)
    redis.flushdb
  end
end
