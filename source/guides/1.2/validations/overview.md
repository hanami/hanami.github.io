---
title: Guides - Validations Overview
version: 1.2
---

# Overview

`Hanami::Validations` is a mixin that, once included by an object, adds lightweight set of validations to it.

It works with input hashes and lets us to define a set of validation rules **for each** key/value pair. These rules are wrapped by lambdas (or special DSL) that check the input for a specific key to determine if it's valid or not. To do that, we translate business requirements into predicates that are chained together with Ruby _faux boolean logic_ operators (eg. `&` or `|`).

Think of a signup form. We need to ensure data integrity for the  `name` field with the following rules. It is required, it has to be: filled **and** a string **and** its size must be greater than 3 chars, but lesser than 64. Here’s the code, **read it aloud** and notice how it perfectly expresses our needs for `name`.

```ruby
class Signup
  include Hanami::Validations

  validations do
    required(:name) { filled? & str? & size?(3..64) }
  end
end

result = Signup.new(name: "Luca").validate
result.success? # => true
```

There is more that `Hanami::Validations` can do: **type safety**, **composition**, **complex data structures**, **built-in and custom predicates**.
