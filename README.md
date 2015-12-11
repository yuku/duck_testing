# DuckTesting

[![Build Status](https://travis-ci.org/yuku-t/duck_testing.svg?branch=master)](https://travis-ci.org/yuku-t/duck_testing) [![Code Climate](https://codeclimate.com/github/yuku-t/duck_testing/badges/gpa.svg)](https://codeclimate.com/github/yuku-t/duck_testing) [![Coverage Status](https://coveralls.io/repos/yuku-t/duck_testing/badge.svg)](https://coveralls.io/r/yuku-t/duck_testing)

Simple data type testing tool

## Usage

### YARD

```rb
require "duck_testing"

DuckTesting::YARD.apply
```

This code automatically generates duck_testing module for all classes in `{lib,app}/**/*.rb` and prepends them into corresponding classes. In most cases, you might put the code in `spec/spec_helper.rb` or `test/test_helper.rb`.

You can include and exclude custom paths by using `paths` and `excluded` arguments. For instance, excluding Rails' controllers and views is written as follows:

```rb
DuckTesting::YARD.apply(excluded: [%r{^app/(controllers|views)}])
```

### Manually

Suppose there are a class and corresponding _duck_testing_ module:

```rb
require "duck_testing"

class Foo
  # @param [Fixnum, Float]
  # @return [Fixnum, Float]
  def double(x)
    x * 2
  end
end

module FooDuckTesting
  def double(x)
    tester = DuckTesting::Tester.new(self, "double")
    tester.test_param(x, [
      DuckTesting::Type::ClassInstance.new(Fixnum),
      DuckTesting::Type::ClassInstance.new(Float)
    ])
    tester.test_return(super, [
      DuckTesting::Type::ClassInstance.new(Fixnum),
      DuckTesting::Type::ClassInstance.new(Float)
    ])
  end
end
```

Now you can activate type testing by prepending _duck_testing_ module into the class:

```rb
before = Foo.new

before.double("2")
# => "22"

Foo.send(:prepend, FooDuckTesting)

after = Foo.new

after.double(2)
# => 4

after.double(2.0)
# => 4.0

after.double("2")
# ContractViolationError: Contract violation for argument Foo#double
```
