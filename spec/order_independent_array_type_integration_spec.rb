describe "OrderIndependentArray type integration spec" do
  subject do
    instance.sum(param)
  end

  before do
    klass.send(:prepend, kata_module)
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

    let(:kata_module) do
      Module.new do
        def sum(array)
          tester = DuckTesting::Tester.new(self, "sum")
          tester.test_param(array, [
            DuckTesting::Type::OrderIndependentArray.new(
              DuckTesting::Type::Class.new(Fixnum),
              DuckTesting::Type::Class.new(Float)
            )
          ])
          tester.test_return(super, [
            DuckTesting::Type::Class.new(Fixnum),
            DuckTesting::Type::Class.new(Float)
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

    let(:kata_module) do
      Module.new do
        def sum(array)
          tester = DuckTesting::Tester.new(self, "sum")
          tester.test_param(array, [
            DuckTesting::Type::OrderIndependentArray.new(
              DuckTesting::Type::Class.new(Fixnum),
              DuckTesting::Type::Class.new(Float)
            )
          ])
          tester.test_return(super, [
            DuckTesting::Type::Class.new(Fixnum),
            DuckTesting::Type::Class.new(Float)
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

    let(:kata_module) do
      Module.new do
        def sum(array)
          tester = DuckTesting::Tester.new(self, "sum")
          tester.test_param(array, [
            DuckTesting::Type::OrderIndependentArray.new(
              DuckTesting::Type::Class.new(Fixnum),
              DuckTesting::Type::Class.new(Float)
            )
          ])
          tester.test_return(super, [
            DuckTesting::Type::Class.new(String)
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
