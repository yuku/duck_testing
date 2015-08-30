module DuckTesting
  class Tester
    attr_reader :call_data

    # @param receiver [Object] the receiver object.
    # @param method_name [String] the invoked method's name.
    def initialize(receiver, method_name)
      @call_data = MethodCallData.new(receiver, method_name)
    end

    # @param param [Object]
    # @param expected_types [Array<Type::Base>]
    def test_param(param, expected_types)
      test(param, expected_types, :param)
    end

    # @param param [Object]
    # @param expected_types [Array<Type::Base>]
    # @return [Object]
    def test_return(param, expected_types)
      test(param, expected_types, :return)
      param
    end

    # @param param [Object]
    # @param expected_types [Array<Type::Base>]
    # @return [true, false]
    def match?(param, expected_types)
      expected_types.any? do |type|
        type.match?(param)
      end
    end

    private

    # @param param [Object]
    # @param expected_types [Array<Type::Base>]
    # @param type [Symbol] `:param` or `:return`
    def test(param, expected_types, type)
      return if match?(param, expected_types)
      violation = Violation.new(
        call_data: call_data,
        param: param,
        expected_types: expected_types,
        param_or_return: type
      )
      Reporter::RaiseError.new(violation).report
    end
  end
end
