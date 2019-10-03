# frozen_string_literal: true

require "pathname"
require "digest/sha1"
require "concurrent/map"

module Brpoplpush
  module RedisScript
    # Interface to dealing with .lua files
    #
    # @author Mikael Henriksson <mikael@zoolutions.se>
    module Client
      SCRIPT_SHAS ||= Concurrent::Map.new

      extend Brpoplpush::RedisScript::Timing
      extend Brpoplpush::RedisScript::Logging

      module_function

      #
      # Call a lua script with the provided file_name
      #
      # @note this method is recursive if we need to load a lua script
      #   that wasn't previously loaded.
      #
      # @param [Symbol] file_name the name of the lua script
      # @param [Array<String>] keys script keys
      # @param [Array<Object>] argv script arguments
      # @param [Redis] conn the redis connection to use
      #
      # @return value from script
      #
      def call(file_name, conn, keys: [], argv: [])
        result, elapsed = timed do
          execute_script(file_name, conn, keys, argv)
        end

        log_debug("Executed #{file_name}.lua in #{elapsed}ms")
        result
      rescue ::Redis::CommandError => ex
        handle_error(ex, file_name, conn) do
          call(file_name, conn, keys: keys, argv: argv)
        end
      end

      #
      # Execute the script file
      #
      # @param [Symbol] file_name the name of the lua script
      # @param [Redis] conn the redis connection to use
      # @param [Array] keys the array of keys to pass to the script
      # @param [Array] argv the array of arguments to pass to the script
      #
      # @return value from script (evalsha)
      #
      def execute_script(file_name, conn, keys, argv)
        conn.evalsha(
          script_sha(conn, file_name),
          keys,
          argv,
        )
      end

      #
      # Return sha of already loaded lua script or load it and return the sha
      #
      # @param [Redis] conn the redis connection
      # @param [Symbol] file_name the name of the lua script
      # @return [String] sha of the script file
      #
      # @return [String] the sha of the script
      #
      def script_sha(conn, file_name)
        if (sha = SCRIPT_SHAS.get(file_name))
          return sha
        end

        sha = conn.script(:load, script_source(file_name))
        SCRIPT_SHAS.put(file_name, sha)
        sha
      end

      #
      # Handle errors to allow retrying errors that need retrying
      #
      # @param [Redis::CommandError] ex exception to handle
      # @param [Symbol] file_name the name of the lua script
      # @param [Redis] conn the redis connection to use
      #
      # @return [void]
      #
      # @yieldreturn [void] yields back to the caller when NOSCRIPT is raised
      def handle_error(ex, file_name, conn) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
        case ex.message
        when "NOSCRIPT No matching script. Please use EVAL."
          SCRIPT_SHAS.delete(file_name)
          return yield if block_given?
        when "BUSY Redis is busy running a script. You can only call SCRIPT KILL or SHUTDOWN NOSAVE."
          begin
            conn.script(:kill)
            return yield if block_given?
          rescue ::Redis::CommandError => ex
            log_warn(ex)
            return yield if block_given?
          end
        end

        raise unless Error.intercepts?(ex)

        raise Error.new(ex, script_path(file_name).to_s, script_source(file_name))
      end

      #
      # Reads the lua file from disk
      #
      # @param [Symbol] file_name the name of the lua script
      #
      # @return [String] the content of the lua file
      #
      def script_source(file_name)
        Template.new(RedisScript.config.script_directory).render(script_path(file_name))
      end

      # Construct a Pathname to a lua script
      #
      # @param [Symbol] file_name the name of the lua script
      #
      # @return [Pathname] the full path to the gems lua script
      #
      def script_path(file_name)
        RedisScript.config.script_directory.join("#{file_name}.lua")
      end
    end
  end
end
