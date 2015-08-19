describe RKata::MethodCallData do
  let(:call_data) { described_class.new(*params) }
  let(:params) { [receiver, method_name] }
  let(:receiver) { nil }
  let(:method_name) { nil }

  describe "#method_expr" do
    subject { call_data.method_expr }

    let(:klass) do
      Class.new do
        def self.name
          "Foo::Bar"
        end
      end
    end
    let(:receiver) { klass.new }
    let(:method_name) { "method_name" }

    it 'returns "Class#method" style method name' do
      should eq "#{klass.name}##{method_name}"
    end
  end
end
