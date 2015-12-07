require "duck_testing/yard/code_object"

module DuckTesting
  module YARD
    # Encapsulate `YARD::CodeObjects::MethodObject`.
    class MethodObject < CodeObject
      # @!attribute [r] name
      #   Returns the name of the object.
      #
      #   @return [String]
      def_delegators :@yard_object, "name"

      # @return [String]
      def signature
        "#{name}(#{parameters_signature})"
      end

      # @return [Array<DuckTesting::YARD::MethodParameter>]
      def method_parameters
        @method_parameters ||= yard_object.parameters.map do |name, default|
          MethodParameter.new(self, name, default, get_parameter_tag(name))
        end
      end

      # @return [YARD::Tags::Tag]
      def return_tag
        @return_tag ||= yard_object.tags.find { |tag| tag.tag_name == "return" }
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
          name == name.end_with?(":") ? "#{tag.name}:" : tag.name
        end
      end

      # @return [Array<YARD::Tags::Tag>]
      def parameter_tags
        @parameter_tags ||= yard_object.tags.select { |tag| tag.tag_name == "param" }
      end
    end
  end
end
