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

      # @return [Boolean]
      def keyword?
        name.end_with?(":")
      end

      # @return [Symbol, nil]
      def key_name
        keyword? ? name[0...-1].to_sym : nil
      end

      # @return [Array<DuckTesting::Type::Base>]
      def expected_types
        parameter_tag.types.map do |type|
          if type == "Boolean"
            [
              DuckTesting::Type::Constant.new(true),
              DuckTesting::Type::Constant.new(false),
            ]
          elsif DuckTesting::Type::Constant::CONSTANTS.include?(type)
            DuckTesting::Type::Constant.new(type)
          elsif type == "void"
            nil
          elsif type.start_with?("Array")
            # TODO: Support specifing types of array elements.
            DuckTesting::Type::ClassInstance.new(Array)
          else
            DuckTesting::Type::ClassInstance.new(Object.const_get(type))
          end
        end.flatten.compact
      end
    end
  end
end
