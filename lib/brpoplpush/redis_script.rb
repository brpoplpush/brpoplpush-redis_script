# frozen_string_literal: true

require "concurrent/map"
require "concurrent/mutable_struct"
require "logger"
require "redis"

require "brpoplpush/redis_script/version"
require "brpoplpush/redis_script/template"
require "brpoplpush/redis_script/error"
require "brpoplpush/redis_script/config"
require "brpoplpush/redis_script/timing"
require "brpoplpush/redis_script/logging"
require "brpoplpush/redis_script/client"

module Brpoplpush
  # Interface to dealing with .lua files
  #
  # @author Mikael Henriksson <mikael@zoolutions.se>
  module RedisScript
    module_function

    # Configure the gem
    #
    # This is usually called once at startup of an application
    # @param [Hash] options global gem options
    # @option options [Integer] :default_lock_timeout (default is 0)
    # @option options [true,false] :enabled (default is true)
    # @option options [String] :unique_prefix (default is 'uniquejobs')
    # @option options [Logger] :logger (default is Logger.new(STDOUT))
    # @yield control to the caller when given block
    def configure(options = {})
      if block_given?
        yield config
      else
        options.each do |key, val|
          config.send("#{key}=", val)
        end
      end
    end

    #
    # The current configuration (See: {.configure} on how to configure)
    #
    #
    # @return [RedisScript::Config] the gem configuration
    #
    def config
      # Arguments here need to match the definition of the new class (see above)
      @config ||= Config.default
    end

    #
    # The current logger
    #
    #
    # @return [Logger] the configured logger
    #
    def logger
      config.logger
    end

    #
    # The current gem version
    #
    #
    # @return [String] the current gem version
    #
    def version
      VERSION
    end

    #
    # Set a new logger
    #
    # @param [Logger] other another logger
    #
    # @return [Logger] the new logger
    #
    def logger=(other)
      config.logger = other
    end

    #
    # Call a lua script with the provided file_name
    #
    #
    # @param [Symbol] file_name the name of the lua script
    # @param [Array<String>] keys script keys
    # @param [Array<Object>] argv script arguments
    # @param [Redis] conn the redis connection to use
    #
    # @return value from script
    #
    def call(file_name, conn, keys: [], argv: [])
      Client.call(file_name, conn, keys: keys, argv: argv)
    end
  end
end
