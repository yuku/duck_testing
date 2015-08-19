# RKata

[![Build Status](https://travis-ci.org/yuku-t/rkata.svg?branch=master)](https://travis-ci.org/yuku-t/rkata) [![Code Climate](https://codeclimate.com/github/yuku-t/rkata/badges/gpa.svg)](https://codeclimate.com/github/yuku-t/rkata) [![Coverage Status](https://coveralls.io/repos/yuku-t/rkata/badge.svg)](https://coveralls.io/r/yuku-t/rkata)

Simple data type testing tool

## Usage

Suppose there are a class and corresponding _kata_ module:

```rb
require "rkata"

class Foo
  # @param [Fixnum, Float]
  # @return [Fixnum, Float]
  def double(x)
    x * 2
  end
end

module FooKata
  def double(x)
    tester = RKata::Tester.new(self, "double")
    tester.test_param(x, [Fixnum, Float])
    result = super
    tester.test_return(result, [Fixnum, Float])
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
