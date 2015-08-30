# DuckTesting

[![Build Status](https://travis-ci.org/yuku-t/duck_testing.svg?branch=master)](https://travis-ci.org/yuku-t/duck_testing) [![Code Climate](https://codeclimate.com/github/yuku-t/duck_testing/badges/gpa.svg)](https://codeclimate.com/github/yuku-t/duck_testing) [![Coverage Status](https://coveralls.io/repos/yuku-t/duck_testing/badge.svg)](https://coveralls.io/r/yuku-t/duck_testing)

Simple data type testing tool

## Usage

Suppose there are a class and corresponding _kata_ module:

```rb
require "duck_testing"

class Foo
  # @param [Fixnum, Float]
  # @return [Fixnum, Float]
  def double(x)
    x * 2
  end
end

module FooKata
  def double(x)
    tester = DuckTesting::Tester.new(self, "double")
    tester.test_param(x, [
      DuckTesting::Type::ClassInstance.new(Fixnum),
      DuckTesting::Type::ClassInstance.new(Float)
    ])
    result = super
    tester.test_return(result, [
      DuckTesting::Type::ClassInstance.new(Fixnum),
      DuckTesting::Type::ClassInstance.new(Float)
    ])
    result
  end
end
```

Now you can activate type testing by prepending _kata_ module into the class:

```rb
before = Foo.new

before.double("2")
# => "22"

Foo.send(:prepend, FooKata)

after = Foo.new

after.double(2)
# => 4

after.double(2.0)
# => 4.0

after.double("2")
# ContractViolationError: Contract violation for argument Foo#double
```

## TODO

- Generate _kata_ module by YARD document.
- RSpec integration.
