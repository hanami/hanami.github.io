---
title: Guides - Validations Overview
---

# Overview

Validations in Hanami happen through `dry-validation` gem provided by [dry.rb](http://dry-rb.org). `dry-validation` focuses on clarity, explicitness and precision of validation logic. It provides several built-in and ready to use predicates to validate the input data for your actions.

## Basic example

```
module Web::Controllers::Signup
  class MyParams < Web::Action::Params
    MEGABYTE = 1024 ** 2

    params do
      required(:name).filled(:str?)
      required(:email).filled(:str?, format?: /@/).confirmation
      required(:password).filled(:str?).confirmation
      required(:terms_of_service).filled(:bool?)
      required(:age).filled(:int?, included_in?: 18..99)
      optional(:avatar).filled(size?: 1..(MEGABYTE * 3)
    end
  end
end
```

## Predicates list

- `none?`
  - checks that a key's value is nill

- `eql?`
  - checks that a key’s value is equal to the given value

- `type?`
  - checks that a key’s class is equal to the given value

Shorthand for common Ruby types:

    `str?` equivalent to `type?(String)`
    `int?` equivalent to `type?(Integer)`
    `float?` equivalent to `type?(Float)`
    `decimal?` equivalent to `type?(BigDecimal)`
    `bool?` equivalent to `type?(Boolean)`
    `date?` equivalent to `type?(Date)`
    `time?` equivalent to `type?(Time)`
    `date_time?` equivalent to `type?(DateTime)`
    `array?` equivalent to `type?(Array)`
    `hash?` equivalent to `type?(Hash)`


- `empty?`
  - checks that either the array, string, or hash is empty

- `filled?`
  - checks that either the value is non-nil and, in the case of a String, Hash, or Array, non-empty

- `gt?`
  - checks that the value is greater than the given value

- `gteq?`
  - checks that the value is greater than or equal to the given value

- `lt?`
  - checks that the value is less than the given value

- `lteq?`
  - checks that the value is less than or equal to the given value

- `max_size?`
  - check that an array’s size (or a string’s length) is less than or equal to the given value

- `min_size?`
  - checks that an array’s size (or a string’s length) is greater than or equal to the given value
  
- `size?(int)`
  - checks that an array’s size (or a string’s length) is equal to the given value

- `size?(range)`
  - checks that an array’s size (or a string’s length) is within a range of values
  
- `format?`
  - checks that a string matches a given regular expression

- `included_in?`
  - checks that a value is included in a given array

- `excluded_from?`
  - checks that a value is excluded from a given array

Doc for validation:

https://github.com/hanami/validations
