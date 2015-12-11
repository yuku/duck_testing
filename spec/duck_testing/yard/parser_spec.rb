describe DuckTesting::YARD::Parser do
  describe ".parse_string" do
    subject { described_class.parse_string(content) }
    let(:content) do
      <<-EOF
class Foo
  # Reverses the contents of a String or IO object.
  #
  # @param [String, #read] contents the contents to reverse
  # @return [String] the contents reversed lexically
  def reverse(contents)
    contents = contents.read if contents.respond_to? :read
    contents.reverse
  end
end
      EOF
    end

    it "returns an array of DuckTesting::YARD::ClassObject" do
      should all be_a DuckTesting::YARD::ClassObject

      class_object = subject.first
      expect(class_object.path).to eq "Foo"
      expect(class_object.method_objects).to all be_a DuckTesting::YARD::MethodObject

      method_object = class_object.method_objects.first
      expect(method_object.path).to eq "Foo#reverse"
      expect(method_object.method_parameters).to all be_a DuckTesting::YARD::MethodParameter

      method_parameter = method_object.method_parameters.first
      expect(method_parameter.name).to eq "contents"
      expect(method_parameter.parameter_tag.types).to eq ["String", "#read"]

      return_tag = method_object.return_tag
      expect(return_tag.types).to eq ["String"]
    end
  end
end
