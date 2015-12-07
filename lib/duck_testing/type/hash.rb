require "duck_testing/type/base"

module DuckTesting
  module Type
    class Hash < Base
      attr_reader :key_types, :value_types

      # @param key_types [Array<DuckTesting::Type::Base>]
      # @param value_types [Array<DuckTesting::Type::Base>]
      def initialize(key_types, value_types)
        @key_types = key_types
        @value_types = value_types
      end

      # @param object [Object]
      # @return [Boolean]
      def match?(object)
        return false unless object.is_a?(::Hash)
        match_keys?(object) && match_values?(object)
      end

      # @return [String]
      def to_s
        "Hash{#{key_types_to_s} => #{value_types_to_s}}"
      end

      private

      # @param hash [Hash]
      # @return [Boolean]
      def match_keys?(hash)
        hash.keys.all? do |key|
          key_types.all? do |type|
            type.match?(key)
          end
        end
      end

      # @param hash [Hash]
      # @return [Boolean]
      def match_values?(hash)
        hash.values.all? do |key|
          value_types.all? do |type|
            type.match?(key)
          end
        end
      end

      # @return [String]
      def key_types_to_s
        key_types.map(&:to_s).join(", ")
      end

      # @return [String]
      def value_types_to_s
        value_types.map(&:to_s).join(", ")
      end
    end
  end
end
