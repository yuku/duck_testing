describe RKata::Reporter::RaiseError do
  let(:reporter) { described_class.new(violation) }
  let(:violation) { RKata::Violation.new(violation_param) }
  let(:violation_param) do
    { call_data: call_data,
      expected_types: [] }
  end
  let(:call_data) { RKata::MethodCallData.new("receiver", "mehtod_name") }

  describe "#report" do
    subject { reporter.report }

    context "when violation#param? is true" do
      before do
        allow(violation).to receive(:param?).and_return(true)
      end

      it "raise ContractViolationError" do
        expect { subject }.to raise_error(RKata::ContractViolationError)
        expect { subject }.to raise_error(/Contract violation for argument/)
      end
    end

    context "when violation#return? is true" do
      before do
        allow(violation).to receive(:return?).and_return(true)
      end

      it "raise ContractViolationError" do
        expect { subject }.to raise_error(RKata::ContractViolationError)
        expect { subject }.to raise_error(/Contract violation for return value/)
      end
    end
  end
end
