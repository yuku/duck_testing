module DuckTesting
  module Type
    class Base
      def match?(_object)
        fail NotImplementedError
      end

      def to_s
        fail NotImplementedError
      end
    end
  end
end
