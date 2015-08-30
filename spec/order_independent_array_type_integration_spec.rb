describe "OrderIndependentArray type integration spec" do
  subject do
    instance.sum(param)
  end

  before do
    klass.send(:prepend, duck_testing_module)
  end

  let(:instance) { klass.new }

  let(:klass) do
    Class.new do
      # @param array [Array<Fixnum, Float>]
      # @return [Fixnum, Float]
      def sum(array)
        array.reduce(&:+)
      end
    end
  end

  context "when expected parameter and return are given" do
    let(:param) { [1, 0.1] }

    let(:duck_testing_module) do
      Module.new do
        def sum(array)
          tester = DuckTesting::Tester.new(self, "sum")
          tester.test_param(array, [
            DuckTesting::Type::OrderIndependentArray.new(
              DuckTesting::Type::ClassInstance.new(Fixnum),
              DuckTesting::Type::ClassInstance.new(Float)
            )
          ])
          tester.test_return(super, [
            DuckTesting::Type::ClassInstance.new(Fixnum),
            DuckTesting::Type::ClassInstance.new(Float)
          ])
        end
      end
    end

    it "does not raise error" do
      expect { subject }.not_to raise_error
    end

    it "returns original result" do
      should eq 1.1
    end
  end

  context "when unexpected parameter is given" do
    let(:param) { "string" }

    let(:duck_testing_module) do
      Module.new do
        def sum(array)
          tester = DuckTesting::Tester.new(self, "sum")
          tester.test_param(array, [
            DuckTesting::Type::OrderIndependentArray.new(
              DuckTesting::Type::ClassInstance.new(Fixnum),
              DuckTesting::Type::ClassInstance.new(Float)
            )
          ])
          tester.test_return(super, [
            DuckTesting::Type::ClassInstance.new(Fixnum),
            DuckTesting::Type::ClassInstance.new(Float)
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
    let(:param) { [1, 0.1] }

    let(:duck_testing_module) do
      Module.new do
        def sum(array)
          tester = DuckTesting::Tester.new(self, "sum")
          tester.test_param(array, [
            DuckTesting::Type::OrderIndependentArray.new(
              DuckTesting::Type::ClassInstance.new(Fixnum),
              DuckTesting::Type::ClassInstance.new(Float)
            )
          ])
          tester.test_return(super, [
            DuckTesting::Type::ClassInstance.new(String)
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
