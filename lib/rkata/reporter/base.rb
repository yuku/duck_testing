module RKata
  module Reporter
    class Base
      attr_reader :violation

      # @param [Violation]
      def initialize(violation)
        @violation = violation
      end

      # Report contract violation.
      def report
        fail NotImplementedError
      end
    end
  end
end
