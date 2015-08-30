describe DuckTesting::Tester do
  let(:tester) { described_class.new(*constract_param) }
  let(:constract_param) { [receiver, method_name] }
  let(:receiver) { nil }
  let(:method_name) { nil }

  shared_context "param matches to expected_types", match: true do
    let(:param) { 1 }
    let(:expected_types) do
      [
        DuckTesting::Type::Class.new(Fixnum),
        DuckTesting::Type::Class.new(Float)
      ]
    end
  end

  shared_context "param does not match to expected_types", match: false do
    let(:param) { 1 }
    let(:expected_types) do
      [DuckTesting::Type::Class.new(Float)]
    end
  end

  describe "#test_param" do
    subject { tester.test_param(param, expected_types) }

    context "when param matches to expected_types", match: true do
      it "does not raise error" do
        expect { subject }.not_to raise_error
      end
    end

    context "when param does not match to expected_types", match: false do
      it "raise ContractViolationError" do
        expect { subject }.to raise_error(DuckTesting::ContractViolationError)
        expect { subject }.to raise_error(/Contract violation for argument/)
      end
    end
  end

  describe "#test_return" do
    subject { tester.test_return(param, expected_types) }

    context "when param matches to expected_types", match: true do
      it "does not raise error" do
        expect { subject }.not_to raise_error
      end

      it "returns the given param" do
        should eq param
      end
    end

    context "when param does not match to expected_types", match: false do
      it "raise ContractViolationError" do
        expect { subject }.to raise_error(DuckTesting::ContractViolationError)
        expect { subject }.to raise_error(/Contract violation for return value/)
      end
    end
  end

  describe "#match?" do
    subject { tester.match?(param, expected_types) }

    context "when param is a one of expected_types", match: true do
      it { should be true }
    end

    context "when param is not a kind of expected_types", match: false do
      it { should be false }
    end
  end
end
