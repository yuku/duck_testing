describe DuckTesting::YARD::Builder do
  describe '#build' do
    subject { builder.build(scope) }
    let(:builder) { described_class.new(class_object) }
    let(:class_object) { DuckTesting::YARD::Parser.parse_string(content).first }
    let(:params) { {} }

    context 'when scope parameter is :instance' do
      before { klass.prepend(subject) }
      let(:contents) { "Hello, World" }
      let(:instance) { klass.new }
      let(:run) { instance.bar(params) }
      let(:scope) { :instance }

      context 'and return tag comment is given' do
        let(:content) do
          <<-EOF
            class Foo
              # @!method bar
              #   @return [String]
            end
          EOF
        end

        context 'and corresponding method returns valid type object' do
          let(:klass) do
            Class.new do
              def bar(_params)
                "String"
              end
            end
          end
          it { expect { run }.not_to raise_error }
        end

        context 'and corresponding method returns invalid type object' do
          let(:klass) do
            Class.new do
              def bar(_params)
                :Symbol
              end
            end
          end
          it { expect { run }.to raise_error(DuckTesting::ContractViolationError) }
        end
      end
    end

    context 'when scope parameter is :class' do
      before { klass.singleton_class.prepend(subject) }
      let(:run) { klass.bar(params) }
      let(:scope) { :class }

      context 'and return tag comment is given' do
        let(:content) do
          <<-EOF
            class Foo
              # @!method self.bar
              #   @return [String]
            end
          EOF
        end

        context 'and corresponding method returns valid type object' do
          let(:klass) do
            Class.new do
              def self.bar(_params)
                "String"
              end
            end
          end
          it { expect { run }.not_to raise_error }
        end

        context 'and corresponding method returns invalid type object' do
          let(:klass) do
            Class.new do
              def self.bar(_params)
                :Symbol
              end
            end
          end
          it { expect { run }.to raise_error(DuckTesting::ContractViolationError) }
        end
      end
    end
  end
end
