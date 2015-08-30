require "duck_testing/type/base"

module DuckTesting
  module Type
    class ClassInstance < Base
      attr_reader :klass

      def initialize(klass)
        @klass = klass
      end

      # @param object [Object]
      # @return [true, false]
      def match?(object)
        object.is_a?(klass)
      end

      # @return [String]
      def to_s
        klass.name
      end
    end
  end
end
