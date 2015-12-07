module DuckTesting
  module YARD
    class MethodParameter
      attr_reader :method_object, :name, :default, :parameter_tag

      # @param method_object [DuckTesting::YARD::MethodObject]
      # @param name [String]
      # @param default [String]
      # @param parameter_tag [YARD::Tags::Tag]
      def initialize(method_object, name, default, parameter_tag)
        @method_object = method_object
        @name = name
        @default = default
        @parameter_tag = parameter_tag
      end

      # @return [String]
      def expected_types
        parameter_tag.types.join(", ")
      end

      # @return [String]
      def to_s
        if default.nil?
          name
        elsif name.end_with?(":")
          "#{name} #{default}"
        else
          "#{name} = #{default}"
        end
      end

      # @return [Boolean]
      def documented?
        !parameter_tag.nil?
      end
    end
  end
end
