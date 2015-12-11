describe Sample do
  let(:sample) { described_class.new }

  describe "#multiplex" do
    subject { sample.multiplex(text, count) }

    context "when valid parameters are given" do
      let(:text) { "sample" }
      let(:count) { 3 }
      it { should eq "samplesamplesample" }
    end

    context "when invalid parameters are given" do
      let(:text) { 3 }
      let(:count) { 3 }
      it { expect { subject }.to raise_error(DuckTesting::ContractViolationError) }
    end
  end

  describe "#double" do
    subject { sample.double(number) }

    context "when valid parameters are given" do
      let(:number) { 3 }
      it { should eq 6 }
    end

    context "when invalid parameters are given" do
      let(:number) { "sample" }
      it { expect { subject }.to raise_error(DuckTesting::ContractViolationError) }
    end
  end
end
