module DuckTesting
  module YARD
    class Builder
      # @param class_object [DuckTesting::YARD::ClassObject]
      def initialize(class_object)
        @class_object = class_object
      end

      # Build duck testing for the `@class_object`.
      #
      # @param scope [Symbol] `:instance` or `:class`
      # @return [Module] duck testing module of `class_object` in the `scope`.
      def build(scope = :instance)
        @building_module = Module.new
        @class_object.method_objects.each do |method_object|
          next unless method_object.scope == scope
          handle_method_object(method_object)
        end
        @building_module
      ensure
        remove_instance_variable :@building_module
      end

      private

      # @param method_object [DuckTesting::YARD::MethodObject]
      def handle_method_object(method_object)
        @building_module.module_eval do
          define_method method_object.name do |*args|
            tester = DuckTesting::Tester.new(self, method_object.name)

            tester.test_return(super(*args), method_object.expected_return_types)
          end
        end
      end

      # @param method_parameter [DuckTesting::YARD::MethodParameter]
      def handle_method_parameter(method_parameter)
        return unless method_parameter.documented?
        @buffer << "    tester.test_param(#{method_parameter.name}, [\n"
        method_parameter.parameter_tag.types.each do |type|
          handle_type(type)
        end
        @buffer << "    ])\n"
      end
    end
  end
end
