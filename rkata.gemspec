lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "rkata"

Gem::Specification.new do |spec|
  spec.name        = "rkata"
  spec.version     = RKata::VERSION
  spec.authors     = ["Yuku Takahashi"]
  spec.email       = ["taka84u9@gmail.com"]
  spec.summary     = "Data type testing tool"
  spec.description = "Data type testing tool"
  spec.license     = "MIT"

  spec.files       = `git ls-files -z`.split("\x0")
  spec.homepage    = "https://github.com/yuku-t/rkata"

  spec.add_development_dependency "rake", "~> 10.0"
end
