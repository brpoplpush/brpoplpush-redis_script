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

      attr_reader :script_directory, :debug_lua, :logger

      def initialize
        @script_directory = nil
        @debug_lua        = DEBUG_LUA
        @logger           = LOGGER
      end

      def script_directory=(obj)
        @script_directory =
          case obj
          when String
            Pathname.new(obj)
          when Pathname
            obj
          else
            raise ArgumentError, "obj needs to be a Pathname or String"
          end
      end

      def logger=(obj)
        raise ArgumentError, "obj needs to be a Logger" unless obj.is_a?(Logger)

        @logger = obj
      end

      def debug_lua=(obj)
        @debug_lua =
          case obj
          when TrueClass, FalseClass, NilClass
            obj
          else
            raise ArgumentError, "obj needs to be a Logger" unless obj.is_a?(Truy)
          end
      end
    end
  end
end
