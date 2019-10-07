# frozen_string_literal: true

module Brpoplpush
  module RedisScript
    #
    # Class holding gem configuration
    #
    # @author Mikael Henriksson <mikael@mhenrixon.com>
    class Config
      DEBUG_LUA        = false
      LOGGER           = Logger.new(STDOUT)
      SCRIPT_DIRECTORY = nil

      attr_accessor :script_directory, :debug_lua, :logger

      def initialize
        self.script_directory = nil
        self.debug_lua        = DEBUG_LUA
        self.logger           = LOGGER
      end
    end
  end
end
