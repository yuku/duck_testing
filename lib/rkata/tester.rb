module RKata
  class Tester
    attr_reader :call_data

    # @param [Object] the receiver object.
    # @param [String] the invoked method's name.
    def initialize(receiver, method_name)
      @call_data = MethodCallData.new(receiver, method_name)
    end

    # @param [Object]
    # @param [Array<Class>]
    def test_param(param, expected_types)
      test(param, expected_types, :param)
    end

    # @param [Object]
    # @param [Array<Class>]
    def test_return(param, expected_types)
      test(param, expected_types, :return)
    end

    # @param [Object]
    # @param [Array<Class>]
    # @return [true, false]
    def match?(param, expected_types)
      !expected_types.all? { |t| !param.is_a?(t) }
    end

    private

    # @param [Object]
    # @param [Array<Class>]
    # @param [Symbol] `:param` or `:return`
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
