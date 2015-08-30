describe "OrderIndependentArray type integration spec" do
  subject do
    instance.find(*params)
  end

  before do
    klass.send(:prepend, kata_module)
  end

  let(:instance) { klass.new }

  let(:klass) do
    Class.new do
      # @param keylist [Array<Array<(Symbol, Object)>>]
      # @param key [Symbol]
      # @return [Object]
      def find(keylist, key)
        keylist.each do |(k, value)|
          return value if k == key
        end
        nil
      end
    end
  end

  context "when expected parameter and return are given" do
    let(:params) { [[[:a, 1], [:b, 2]], :b] }

    let(:kata_module) do
      Module.new do
        def find(keylist, key)
          tester = DuckTesting::Tester.new(self, "find")
          tester.test_param(keylist, [
            DuckTesting::Type::OrderIndependentArray.new(
              DuckTesting::Type::OrderDependentArray.new(
                DuckTesting::Type::Class.new(Symbol),
                DuckTesting::Type::Class.new(Object)
              )
            )
          ])
          tester.test_param(key, [
            DuckTesting::Type::Class.new(Symbol)
          ])
          result = super
          tester.test_return(result, [
            DuckTesting::Type::Class.new(Object)
          ])
          result
        end
      end
    end

    it "does not raise error" do
      expect { subject }.not_to raise_error
    end

    it "returns original result" do
      should eq 2
    end
  end

  context "when unexpected parameter is given" do
    let(:params) { [[["a", 1], ["b", 2]], "b"] }

    let(:kata_module) do
      Module.new do
        def find(keylist, key)
          tester = DuckTesting::Tester.new(self, "find")
          tester.test_param(keylist, [
            DuckTesting::Type::OrderIndependentArray.new(
              DuckTesting::Type::OrderDependentArray.new(
                DuckTesting::Type::Class.new(Symbol),
                DuckTesting::Type::Class.new(Object)
              )
            )
          ])
          tester.test_param(key, [
            DuckTesting::Type::Class.new(Symbol)
          ])
          result = super
          tester.test_return(result, [
            DuckTesting::Type::Class.new(Object)
          ])
          result
        end
      end
    end

    it "raises ContractViolationError" do
      expect { subject }.to raise_error(DuckTesting::ContractViolationError)
      expect { subject }.to raise_error(/Contract violation for argument/)
    end
  end

  context "when unexpected result is given" do
    let(:params) { [[[:a, 1], [:b, 2]], :b] }

    let(:kata_module) do
      Module.new do
        def find(keylist, key)
          tester = DuckTesting::Tester.new(self, "find")
          tester.test_param(keylist, [
            DuckTesting::Type::OrderIndependentArray.new(
              DuckTesting::Type::OrderDependentArray.new(
                DuckTesting::Type::Class.new(Symbol),
                DuckTesting::Type::Class.new(Object)
              )
            )
          ])
          tester.test_param(key, [
            DuckTesting::Type::Class.new(Symbol)
          ])
          result = super
          tester.test_return(result, [
            DuckTesting::Type::Class.new(Symbol)
          ])
          result
        end
      end
    end

    it "raises ContractViolationError" do
      expect { subject }.to raise_error(DuckTesting::ContractViolationError)
      expect { subject }.to raise_error(/Contract violation for return value/)
    end
  end
end
