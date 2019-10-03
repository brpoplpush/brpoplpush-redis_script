# frozen_string_literal: true

module Brpoplpush
  module RedisScript
    # ThreadSafe config exists to be able to document the config class without errors
    ThreadSafeConfig = Concurrent::MutableStruct.new("ThreadSafeConfig",
                                                     :debug_lua,
                                                     :logger,
                                                     :script_directory)

    #
    # Shared class for dealing with gem configuration
    #
    # @author Mauro Berlanda <mauro.berlanda@gmail.com>
    class Config < ThreadSafeConfig
      DEBUG_LUA        = false
      LOGGER           = ::Logger.new(STDOUT)
      SCRIPT_DIRECTORY = nil

      #
      # Returns a default configuration
      #
      # @example
      #   RedisScript::Config.default => <concurrent/mutable_struct/thread_safe_config RedisScript::Config {
      #   logger: #<Logger:0x00007f81e096b0e0 @level=1 ...>,
      #   debug_lua: false,
      #   }>
      #
      #
      # @return [RedisScript::Config] a default configuration
      #
      def self.default
        new(DEBUG_LUA, LOGGER, SCRIPT_DIRECTORY)
      end
    end
  end
end
