describe "Constant type integration spec" do
  subject do
    instance.not(param)
  end

  before do
    klass.send(:prepend, duck_testing_module)
  end

  let(:instance) { klass.new }

  let(:klass) do
    Class.new do
      # @param a [true, false]
      # @return [true, false]
      def not(a)
        !a
      end
    end
  end

  context "when expected parameter and return are given" do
    let(:param) { true }

    let(:duck_testing_module) do
      Module.new do
        def not(a)
          tester = DuckTesting::Tester.new(self, "not")
          tester.test_param(a, [
            DuckTesting::Type::Constant.new(true),
            DuckTesting::Type::Constant.new(false)
          ])
          tester.test_return(super, [
            DuckTesting::Type::Constant.new(true),
            DuckTesting::Type::Constant.new(false)
          ])
        end
      end
    end

    it "does not raise error" do
      expect { subject }.not_to raise_error
    end

    it "returns original result" do
      should eq false
    end
  end

  context "when unexpected parameter is given" do
    let(:param) { "string" }

    let(:duck_testing_module) do
      Module.new do
        def not(a)
          tester = DuckTesting::Tester.new(self, "not")
          tester.test_param(a, [
            DuckTesting::Type::Constant.new(true),
            DuckTesting::Type::Constant.new(false)
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
    let(:param) { true }

    let(:duck_testing_module) do
      Module.new do
        def not(a)
          tester = DuckTesting::Tester.new(self, "not")
          tester.test_return(super, [
            DuckTesting::Type::Constant.new(true)
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
