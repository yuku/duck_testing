require "duck_testing/yard/code_object"

module DuckTesting
  module YARD
    # Encapsulate `YARD::CodeObjects::MethodObject`.
    class MethodObject < CodeObject
      # @!attribute [r] name
      #   Returns the name of the object.
      #
      #   @return [String]
      # @!attribute [r] scope
      #   Returns the scope of the object.
      #
      #   @return [Symbol]
      def_delegators :@yard_object, "name", "scope"

      # @return [String]
      def signature
        "#{name}(#{parameters_signature})"
      end

      # @return [Array<DuckTesting::YARD::MethodParameter>]
      def method_parameters
        @method_parameters ||= begin
          if yard_object.parameters.any?
            yard_object.parameters.map do |name, default|
              MethodParameter.new(self, name, default, get_parameter_tag(name))
            end
          elsif parameter_tags.any?
            # Maybe the method is defined using a DSL and its signature is
            # declared with "@!method" directive.
            parameter_tags.map do |tag|
              MethodParameter.new(self, tag.name, nil, tag)
            end
          else
            # The method does not take any arguments.
            []
          end
        end
      end

      # @return [Array<DuckTesting::YARD::MethodParameter>]
      def keyword_parameters
        method_parameters.select(&:keyword?)
      end

      # @return [YARD::Tags::Tag]
      def return_tag
        @return_tag ||= yard_object.tags.find { |tag| tag.tag_name == "return" }
      end

      # @return [Array<DuckTesting::Type::Base>]
      def expected_return_types
        return [] unless return_tag
        return_tag.types.map do |type|
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

      # @return [Boolean]
      def public_instance_method?
        yard_object.scope == :instance
      end

      # @return [Boolean]
      def public_class_method?
        yard_object.scope == :class
      end

      private

      # @return [String]
      def parameters_signature
        method_parameters.map(&:to_s).join(", ")
      end

      # @return [YARD::Tags::Tag]
      def get_parameter_tag(name)
        parameter_tags.find do |tag|
          name == (name.end_with?(":") ? "#{tag.name}:" : tag.name)
        end
      end

      # @return [Array<YARD::Tags::Tag>]
      def parameter_tags
        @parameter_tags ||= yard_object.tags.select { |tag| tag.tag_name == "param" }
      end
    end
  end
end
