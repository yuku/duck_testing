require "duck_testing/yard/code_object"

module DuckTesting
  module YARD
    # Encapsulate `YARD::CodeObjects::ClassObject`.
    class ClassObject < CodeObject
      # @return [Array<DuckTesting::YARD::MethodObject>]
      def method_objects
        @method_objects ||= yard_object.meths.map do |method_object|
          MethodObject.new(method_object)
        end
      end

      # @return [String]
      def verbose_name
        @verbose_name ||= yard_object.path.gsub(/::/, "")
      end
    end
  end
end
