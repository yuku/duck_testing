require "stringio"

describe "Duck type integration spec" do
  subject do
    instance.read(param)
  end

  before do
    klass.send(:prepend, kata_module)
  end

  let(:instance) { klass.new }

  let(:klass) do
    Class.new do
      # @param io [#read]
      # @return [#read]
      def read(io)
        io
      end
    end
  end

  context "when expected parameter and return are given" do
    let(:param) { StringIO.new }

    let(:kata_module) do
      Module.new do
        def read(io)
          tester = DuckTesting::Tester.new(self, "read")
          tester.test_param(io, [
            DuckTesting::Type::DuckType.new("read")
          ])
          tester.test_return(super, [
            DuckTesting::Type::DuckType.new("read")
          ])
        end
      end
    end

    it "does not raise error" do
      expect { subject }.not_to raise_error
    end

    it "returns original result" do
      should eq param
    end
  end

  context "when unexpected parameter is given" do
    let(:param) { "string" }

    let(:kata_module) do
      Module.new do
        def read(io)
          tester = DuckTesting::Tester.new(self, "read")
          tester.test_param(io, [
            DuckTesting::Type::DuckType.new("read")
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
    let(:param) { "string" }

    let(:kata_module) do
      Module.new do
        def read(io)
          tester = DuckTesting::Tester.new(self, "read")
          tester.test_return(super, [
            DuckTesting::Type::DuckType.new("read")
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
