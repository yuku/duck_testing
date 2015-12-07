require "forwardable"

module DuckTesting
  module YARD
    class CodeObject
      extend Forwardable

      attr_reader :yard_object

      # @!attribute [r] path
      #   Represents the unique path of the object.
      #
      #   @return [String]
      def_delegators :@yard_object, "path"

      # @param yard_object [YARD::CodeObjects::Base]
      def initialize(yard_object)
        @yard_object = yard_object
      end
    end
  end
end
