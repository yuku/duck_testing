require "duck_testing/type/base"

module DuckTesting
  module Type
    class OrderIndependentArray < Base
      attr_reader :types

      def initialize(*types)
        @types = types
      end

      # @param [Object] array
      # @return [Boolean]
      def match?(array)
        return false unless array.is_a?(Array)
        array.all? do |array_element|
          types.any? { |type| type.match?(array_element) }
        end
      end

      # @return [String]
      def to_s
        "Array<#{types.map(&:to_s).join(', ')}>"
      end
    end
  end
end
