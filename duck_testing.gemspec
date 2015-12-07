lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "duck_testing"

Gem::Specification.new do |spec|
  spec.name                  = "duck_testing"
  spec.version               = DuckTesting::VERSION
  spec.authors               = ["Yuku Takahashi"]
  spec.email                 = ["taka84u9@gmail.com"]
  spec.summary               = "Data type testing tool"
  spec.description           = "Data type testing tool"
  spec.license               = "MIT"
  spec.required_ruby_version = ">= 2.0"

  spec.files                 = `git ls-files -z`.split("\x0")
  spec.homepage              = "https://github.com/yuku-t/duck_testing"

  spec.add_dependency "yard", "~> 0.8.7"

  spec.add_development_dependency "guard", "~> 2.12"
  spec.add_development_dependency "guard-rspec", "~> 4.6"
  spec.add_development_dependency "guard-rubocop", "~> 1.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "rubocop", "~> 0.32"
end
