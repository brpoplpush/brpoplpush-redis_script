# frozen_string_literal: true

module Brpoplpush
  module RedisScript
    #
    # Class holding gem configuration
    #
    # @author Mikael Henriksson <mikael@mhenrixon.com>
    class Config
      attr_reader :logger, :redis, :scripts_path

      def initialize
        @conn         = Redis.new
        @logger       = Logger.new(STDOUT)
        @scripts_path = nil
      end

      def scripts_path=(obj)
        @scripts_path =
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
    end
  end
end
