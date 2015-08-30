require "duck_testing/type/base"

module DuckTesting
  module Type
    class DuckType < Base
      attr_reader :name

      def initialize(name)
        @name = name
      end

      # @param object [Object]
      # @return [true, false]
      def match?(object)
        object.respond_to?(name)
      end

      # @return [String]
      def to_s
        "##{name}"
      end
    end
  end
end
