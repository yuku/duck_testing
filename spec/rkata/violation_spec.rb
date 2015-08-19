describe RKata::Violation do
  let(:violation) { described_class.new(params) }
  let(:params) do
    { call_data: call_data,
      param: param,
      expected_types: expected_types,
      param_or_return: param_or_return }
  end
  let(:call_data) { nil }
  let(:param) { nil }
  let(:expected_types) { nil }
  let(:param_or_return) { nil }

  describe "#param?" do
    subject { violation.param? }

    context "when param_or_return is :param" do
      let(:param_or_return) { :param }

      it { should be true }
    end

    context "when param_or_return is :return" do
      let(:param_or_return) { :return }

      it { should be false }
    end
  end

  describe "#return?" do
    subject { violation.return? }

    context "when param_or_return is :param" do
      let(:param_or_return) { :param }

      it { should be false }
    end

    context "when param_or_return is :return" do
      let(:param_or_return) { :return }

      it { should be true }
    end
  end

  describe "#expected" do
    subject { violation.expected }

    let(:expected_types) { [Fixnum, Float] }

    it { should eq "Fixnum, Float" }
  end
end
