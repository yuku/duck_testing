module DuckTesting
  module Reporter
    class Base
      attr_reader :violation

      # @param violation [DuckTesting::Violation]
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
