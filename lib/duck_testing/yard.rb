require "duck_testing/yard/builder"
require "duck_testing/yard/parser"

module DuckTesting
  module YARD
    # The default glob of files to be parsed.
    DEFAULT_PATH_GLOB = ["{lib,app}/**/*.rb"]

    module_function

    # Parses a path or set of paths then prepend them into corresponding classes..
    #
    # @param paths [String, Array<String>] a path, glob or list of paths to parse
    # @param excluded [Array<String, Regexp>] a list of excluded path matchers
    # @return [void]
    def apply(paths: DEFAULT_PATH_GLOB, excluded: [])
      Parser.parse(paths, excluded).each do |class_object|
        builder = Builder.new(class_object)
        begin
          klass = Object.const_get(class_object.path)
        rescue NameError
          next
        end
        klass.send(:prepend, builder.build(:instance))
        klass.singleton_class.send(:prepend, builder.build(:class))
      end
    end
  end
end
