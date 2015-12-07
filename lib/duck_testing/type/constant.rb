require "duck_testing/type/base"

module DuckTesting
  module Type
    class Constant < Base
      attr_reader :constant

      def initialize(constant)
        @constant = constant
      end

      # @param object [Object]
      # @return [Boolean]
      def match?(object)
        object == constant
      end

      # @return [String]
      def to_s
        constant.to_s
      end
    end
  end
end
