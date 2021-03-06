describe "Integration spec" do
  subject do
    instance.double(param)
  end

  before do
    klass.send(:prepend, duck_testing_module)
  end

  let(:instance) { klass.new }

  let(:klass) do
    Class.new do
      # @param number [Fixnum, Float]
      # @return [Fixnum, Float]
      def double(number)
        number * 2
      end
    end
  end

  context "when expected parameter and return are given" do
    let(:param) { 1 }

    let(:duck_testing_module) do
      Module.new do
        def double(number)
          tester = DuckTesting::Tester.new(self, "double")
          tester.test_param(number, [
            DuckTesting::Type::ClassInstance.new(Fixnum),
            DuckTesting::Type::ClassInstance.new(Float)
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
      should eq 2
    end
  end

  context "when unexpected parameter is given" do
    let(:param) { "string" }

    let(:duck_testing_module) do
      Module.new do
        def double(number)
          tester = DuckTesting::Tester.new(self, "double")
          tester.test_param(number, [
            DuckTesting::Type::ClassInstance.new(Fixnum),
            DuckTesting::Type::ClassInstance.new(Float)
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
    let(:param) { 1 }

    let(:duck_testing_module) do
      Module.new do
        def double(number)
          tester = DuckTesting::Tester.new(self, "double")
          tester.test_param(number, [
            DuckTesting::Type::ClassInstance.new(Fixnum),
            DuckTesting::Type::ClassInstance.new(Float)
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
