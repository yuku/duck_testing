describe DuckTesting::YARD::Builder do
  describe '#build' do
    subject { builder.build(scope) }
    let(:builder) { described_class.new(class_object) }
    let(:class_object) { DuckTesting::YARD::Parser.parse_string(content).first }
    let(:params) { [] }

    context 'when scope parameter is :instance' do
      before { klass.prepend(subject) }
      let(:contents) { "Hello, World" }
      let(:instance) { klass.new }
      let(:run) { instance.bar(*params) }
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
            Class.new { def bar; "String" end }
          end
          it { expect { run }.not_to raise_error }
        end

        context 'and corresponding method returns invalid type object' do
          let(:klass) do
            Class.new { def bar; :Symbol end }
          end
          it { expect { run }.to raise_error(DuckTesting::ContractViolationError) }
        end
      end

      context 'and param tag comment is given' do
        context 'and there is a parameter without default value' do
          let(:content) do
            <<-EOF
              class Foo
                # @!method bar
                #   @param name [String]
              end
            EOF
          end
          let(:klass) do
            Class.new { def bar(_name) end }
          end
          context 'and valid type object is given as the parameter' do
            let(:params) { ["String"] }
            it { expect { run }.not_to raise_error }
          end

          context 'and invalid type object is given as the parameter' do
            let(:params) { [:String] }
            it { expect { run }.to raise_error(DuckTesting::ContractViolationError) }
          end
        end

        context 'and there is a parameter with default value' do
          let(:content) do
            <<-EOF
              class Foo
                # @!method bar
                #   @param name [String]
              end
            EOF
          end
          let(:klass) do
            Class.new { def bar(_name = nil) end }
          end

          context 'and the parameter is omitted' do
            it { expect { run }.not_to raise_error }
          end

          context 'and valid type object is given as the parameter' do
            let(:params) { ["String"] }
            it { expect { run }.not_to raise_error }
          end

          context 'and invalid type object is given as the parameter' do
            let(:params) { [:String] }
            it { expect { run }.to raise_error(DuckTesting::ContractViolationError) }
          end
        end

        context 'and there is a keyword parameter' do
          let(:content) do
            <<-EOF
              class Foo
                # @param key [String]
                def bar(key: nil) end
              end
            EOF
          end
          let(:klass) do
            Class.new { def bar(key: nil) end }
          end

          context 'and valid type object is given as the parameter' do
            let(:params) { [key: "String"] }
            it { expect { run }.not_to raise_error }
          end

          context 'and invalid type object is given as the parameter' do
            let(:params) { [key: :Symbol] }
            it { expect { run }.to raise_error(DuckTesting::ContractViolationError) }
          end
        end

        context 'and there are both an normal paramter and a keyword parameter' do
          let(:content) do
            <<-EOF
              class Foo
                # @param name [String]
                # @param key [String]
                def bar(name, key: nil) end
              end
            EOF
          end
          let(:klass) do
            Class.new { def bar(_name, key: nil) end }
          end

          context 'and valid type objects are given as those parameters' do
            let(:params) { ["String", key: "String"] }
            it { expect { run }.not_to raise_error }
          end

          context 'and invalid type object is given as the normal parameter' do
            let(:params) { [:Symbol, key: "String"] }
            it { expect { run }.to raise_error(DuckTesting::ContractViolationError) }
          end

          context 'and invalid type object is given as the keyword parameter' do
            let(:params) { ["String", key: :Symbol] }
            it { expect { run }.to raise_error(DuckTesting::ContractViolationError) }
          end
        end
      end
    end

    context 'when scope parameter is :class' do
      before { klass.singleton_class.prepend(subject) }
      let(:run) { klass.bar(*params) }
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
            Class.new { def self.bar; "String" end }
          end
          it { expect { run }.not_to raise_error }
        end

        context 'and corresponding method returns invalid type object' do
          let(:klass) do
            Class.new { def self.bar; :Symbol end }
          end
          it { expect { run }.to raise_error(DuckTesting::ContractViolationError) }
        end
      end
    end
  end
end
