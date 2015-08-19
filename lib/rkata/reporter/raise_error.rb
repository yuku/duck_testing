require "rkata/reporter/base"

module RKata
  module Reporter
    class RaiseError < Base
      # @note Override Base#report.
      def report
        fail ContractViolationError, failure_message
      end

      private

      def failure_message
        %(#{message_header}
            Expected: #{violation.expected}
            Actual: #{violation.param.inspect})
      end

      def message_header
        if violation.param?
          "Contract violation for argument of #{violation.method_expr}"
        elsif violation.return?
          "Contract violation for return value from #{violation.method_expr}"
        else
          fail NotImplementedError
        end
      end
    end
  end
end
