module RKata
  class MethodCallData
    # @param receiver [Object] the receiver object.
    # @param method_name [String] the invoked method's name.
    def initialize(receiver, method_name)
      @receiver = receiver
      @method_name = method_name
    end

    # @return [String]
    def method_expr
      "#{receiver.class.name}##{method_name}"
    end

    private

    attr_reader :receiver, :method_name
  end
end
