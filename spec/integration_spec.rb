describe "Integration spec" do
  subject do
    instance.double(param)
  end

  before do
    klass.send(:prepend, kata_module)
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

    let(:kata_module) do
      Module.new do
        def double(*args)
          tester = DuckTesting::Tester.new(self, "double")
          tester.test_param(args[0], [Fixnum, Float])
          result = super
          tester.test_return(result, [Fixnum, Float])
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
    let(:param) { "string" }

    let(:kata_module) do
      Module.new do
        def double(*args)
          tester = DuckTesting::Tester.new(self, "double")
          tester.test_param(args[0], [Fixnum, Float])
          result = super
          tester.test_return(result, [Fixnum, Float])
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
    let(:param) { 1 }

    let(:kata_module) do
      Module.new do
        def double(*args)
          tester = DuckTesting::Tester.new(self, "double")
          tester.test_param(args[0], [Fixnum, Float])
          result = super
          tester.test_return(result, [String])
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
