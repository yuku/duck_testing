describe "Hash type integration spec" do
  subject do
    instance.get(*params)
  end

  before do
    klass.send(:prepend, kata_module)
  end

  let(:instance) { klass.new }

  let(:klass) do
    Class.new do
      # @param hash [Hash{Symbol => Object}]
      # @param key [Symbol]
      # @param default [Object]
      # @return [Object]
      def get(hash, key, default = nil)
        hash.key?(key) ? hash[key] : default
      end
    end
  end

  context "when expected parameter and return are given" do
    let(:params) { [{ a: 1, b: 2 }, :b, "hello"] }

    let(:kata_module) do
      Module.new do
        def get(hash, key, default = nil)
          tester = DuckTesting::Tester.new(self, "get")
          tester.test_param(hash, [
            DuckTesting::Type::Hash.new(
              [DuckTesting::Type::ClassInstance.new(Symbol)],
              [DuckTesting::Type::ClassInstance.new(Object)]
            )
          ])
          tester.test_param(key, [
            DuckTesting::Type::ClassInstance.new(Symbol)
          ])
          tester.test_param(default, [
            DuckTesting::Type::ClassInstance.new(Object)
          ])
          tester.test_return(super, [
            DuckTesting::Type::ClassInstance.new(Object)
          ])
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
    let(:params) { [{ "a" => 1 }, "a"] }

    let(:kata_module) do
      Module.new do
        def get(hash, _key, _default = nil)
          tester = DuckTesting::Tester.new(self, "get")
          tester.test_param(hash, [
            DuckTesting::Type::Hash.new(
              [DuckTesting::Type::ClassInstance.new(Symbol)],
              [DuckTesting::Type::ClassInstance.new(Object)]
            )
          ])
        end
      end
    end

    it "raises ContractViolationError" do
      expect { subject }.to raise_error(DuckTesting::ContractViolationError)
      expect { subject }.to raise_error(/Contract violation for argument/)
    end
  end

  context "when unexpected result is given" do
    let(:params) { [{ a: 1, b: 2 }, :b, "hello"] }

    let(:kata_module) do
      Module.new do
        def get(hash, key, default = nil)
          tester = DuckTesting::Tester.new(self, "get")
          tester.test_param(hash, [
            DuckTesting::Type::Hash.new(
              [DuckTesting::Type::ClassInstance.new(Symbol)],
              [DuckTesting::Type::ClassInstance.new(Object)]
            )
          ])
          tester.test_param(key, [
            DuckTesting::Type::ClassInstance.new(Symbol)
          ])
          tester.test_param(default, [
            DuckTesting::Type::ClassInstance.new(Object)
          ])
          tester.test_return(super, [
            DuckTesting::Type::ClassInstance.new(Symbol)
          ])
        end
      end
    end

    it "raises ContractViolationError" do
      expect { subject }.to raise_error(DuckTesting::ContractViolationError)
      expect { subject }.to raise_error(/Contract violation for return value/)
    end
  end
end
