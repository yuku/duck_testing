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
        @building_module = prepare_module
        @class_object.method_objects.each do |method_object|
          next unless method_object.scope == scope
          handle_method_object(method_object)
        end
        @building_module
      ensure
        remove_instance_variable :@building_module
      end

      # rubocop:disable Lint/NestedMethodDefinition, Metrics/AbcSize

      private

      def prepare_module
        Module.new do
          private

          def __dk_test_normal_parameters(tester, method_object, parameters)
            parameters.each_with_index do |parameter, index|
              tester.test_param(
                parameter,
                method_object.method_parameters[index].expected_types
              )
            end
          end

          def __dk_test_keyword_parameters(tester, method_object, hash_parameter)
            method_object.keyword_parameters.each do |method_parameter|
              next unless hash_parameter.key?(method_parameter.key_name)
              tester.test_param(
                hash_parameter[method_parameter.key_name],
                method_parameter.expected_types
              )
            end
          end
        end
      end

      # @param method_object [DuckTesting::YARD::MethodObject]
      def handle_method_object(method_object)
        @building_module.module_eval do
          define_method method_object.name do |*parameters|
            tester = DuckTesting::Tester.new(self, method_object.name)
            if method_object.keyword_parameters.any? && parameters.last.is_a?(Hash)
              __dk_test_normal_parameters(tester, method_object, parameters[0...-1])
              __dk_test_keyword_parameters(tester, method_object, parameters.last)
            else
              __dk_test_normal_parameters(tester, method_object, parameters)
            end
            tester.test_return(super(*parameters), method_object.expected_return_types)
          end
        end
      end
    end
  end
end
