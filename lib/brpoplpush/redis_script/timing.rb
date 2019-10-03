# frozen_string_literal: true

module Brpoplpush
  module RedisScript
    # Handles timing> of things
    #
    # @author Mikael Henriksson <mikael@zoolutions.se>
    module Timing
      module_function

      #
      # Used for timing method calls
      #
      #
      # @return [yield return, Float]
      #
      def timed
        start_time = clock_stamp

        [yield, clock_stamp - start_time]
      end

      #
      # Returns a float representation of the current time.
      #   Either from Process or Time
      #
      #
      # @return [Float]
      #
      def clock_stamp
        if Process.const_defined?("CLOCK_MONOTONIC")
          Process.clock_gettime(Process::CLOCK_MONOTONIC)
        else
          Time.now.to_f
        end
      end
    end
  end
end
