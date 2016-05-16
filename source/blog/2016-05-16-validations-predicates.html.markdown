---
title: Validations Predicates
date: 2016-05-16 07:37 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Hanami will introduce a new syntax for validations based on predicates. It features builtin and custom predicates, type safety, specific coercions for HTTP params, whitelisting, custom error messages with optional i18n support. This release will start a new alliance between Hanami and dry-rb.
---

For long time [Hanami::Validations](https://github.com/hanami/validations) had problems that we struggled to solve and new features were problematic to add.
Data management is complex task with thousands of cases to cover and because validations deal untrusted input, edge cases are common.
Even simple cases like _blank values_ management became an issue.

We tried to fix these problems, but over the time we realized that we hit the limit of that syntax, which led to lack of flexibility for us and for developers themselves.

At the same time [dry-rb](http://dry-rb.org) folks released a new, stronger validations gem: `dry-validation`.
It chances, for the good, the way we express validation rules.
So we took the decision to radically change our syntax and to adopt `dry-validation` as a validations backend for us.

## How It Will Work?

`Hanami::Validations` will work with input hashes and lets us to define a set of validation rules **for each** key/value pair.
These rules are wrapped by lambdas (or special DSL) that check the input for a specific key to determine if it's valid or not.
To do that, we translate business requirements into predicates that are chained together with Ruby _faux boolean logic_ operators (eg. `&` or `|`).

Think of a signup form.
We need to ensure data integrity for the  `name` field with the following rules.
It is required, it has to be: filled **and** a string **and** its size must be greater than 3 chars, but lesser than 64.
Here’s the code, **read it aloud** and notice how it perfectly expresses our needs for `name`.

```ruby
class Signup
  include Hanami::Validations

  validations do
    required(:name) { filled? & str? & size?(3..64) }
  end
end

result = Signup.new(name: "Luca").validate
result.success? # => true

result = Signup.new({}).validate

result.success? # => false
result.messages.fetch(:name) # => ["must be filled"]
```

### Boolean Logic

When we check data, we expect only two outcomes: an input can be valid or not.
No grey areas, nor fuzzy results.
It’s white or black, 1 or 0, `true` or `false` and _boolean logic_ is the perfect tool to express these two states.
Indeed, a Ruby _boolean expression_ can only return `true` or `false`.

To better recognise the pattern, let’s get back to the example above.
This time we will map the natural language rules with programming language rules.

```
        A name must be filled  and be a string and its size fall between 3 and 64.
           👇            👇     👇        👇    👇       👇                👇    👇
required(:name)      { filled?  &       str?   &      size?              (3 .. 64) }

```

Now, I hope you’ll never format code like that, but in this case, that formatting serves well our purpose to show how Ruby’s  simplicity helps to define complex rules with no effort.

From a high level perspective, we can tell that input data for `name` is _valid_ only if **all** the requirements are satisfied. That’s because we used `&`.

### The Advantages

With this new syntax we give more control to developers: they can decide the order of execution of the validations.
They can define [custom predicates](https://github.com/hanami/validations#custom-predicates) and [custom error messages](https://github.com/hanami/validations#messages), [opt in for internationalization (i18n)](https://github.com/hanami/validations#internationalization-i18n) with small effort.
They can [dry code via macros](https://github.com/hanami/validations#macros), [reuse validators](https://github.com/hanami/validations#composition), [enforce types](https://github.com/hanami/validations#type-safety), [whitelist params](https://github.com/hanami/validations#whitelisting).

To summarize: we fixed old bugs, implemented features that developers asked for, increased internal code robustness and started a new alliance with **dry-rb** <3.

**These chances were just merged in [master](https://github.com/hanami/validations) and they will be released in a few months with `hanami` `v0.8.0`.**
