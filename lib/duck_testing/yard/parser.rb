require "yard"

module DuckTesting
  module YARD
    class Parser
      class << self
        # Parses a path or set of paths.
        #
        # @param paths [String, Array<String>] a path, glob or list of paths to parse
        # @param excluded [Array<String, Regexp>] a list of excluded path matchers
        # @return [Array<DuckTesting::YARD::ClassObject>]
        def parse(paths, excluded)
          ::YARD::Registry.clear
          ::YARD::Parser::SourceParser.parse(paths, excluded)
          ::YARD::Registry.all(:class).map { |class_object| ClassObject.new(class_object) }
        end

        # Parses a string `content`.
        #
        # @param content [String] the block of code to parse.
        # @return [Array<DuckTesting::YARD::ClassObject>]
        def parse_string(content)
          ::YARD::Registry.clear
          ::YARD::Parser::SourceParser.parse_string(content)
          ::YARD::Registry.all(:class).map { |class_object| ClassObject.new(class_object) }
        end
      end
    end
  end
end
