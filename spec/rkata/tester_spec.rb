describe RKata::Tester do
  let(:tester) { described_class.new }

  describe "#test" do
    subject { tester.test(param, expected_types) }

    context "when param is a one of expected_types" do
      let(:param) { 1 }
      let(:expected_types) { [Float, Fixnum] }

      it { should be true }
    end

    context "when param is not a kind of expected_types" do
      let(:param) { 1 }
      let(:expected_types) { [Float] }

      it { should be false }
    end
  end
end
