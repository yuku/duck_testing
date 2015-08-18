module RKata
  class Tester
    # @param [Object]
    # @param [Array<Class>]
    # @return [true, false]
    def test(param, expected_types)
      !expected_types.all? { |t| !param.is_a?(t) }
    end
  end
end
