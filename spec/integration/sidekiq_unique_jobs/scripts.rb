# frozen_string_literal: true

module SidekiqUniqueJobs
  module Scripts
    include Brpoplpush::RedisScript::DSL

    configure do |config|
      config.scripts_path = SCRIPTS_PATH
    end
  end
end
