---
title: Announcing Hanami Validations v2.0.0.alpha1
date: 2019-07-26 13:45:33 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Completely rewritten validation library, compatible with latest DRY & ROM versions. Use it today with Hanami 1!
---

Hello wonderful community! ❤️🌸

Today we're happy to announce `hanami-validations` `v2.0.0.alpha1` release 🙌.

## A new validation experience 😎

While we're continuing the work on Hanami 2, we decided to anticipate the release of the new `hanami-validations`.

As result of the collaboration with [DRY](https://dry-rb.org) & [ROM](https://rom-rb.org), this new version is based on the now stable [`dry-validation`](https://dry-rb.org/gems/dry-validation/) gem.

The most noteworthy change is the introduction of `Hanami::Validator`, a new superclass to inherit from:

```ruby
# frozen_string_literal: true

require "hanami/validations"

class SignupValidator < Hanami::Validator
  schema do
    required(:email).value(:string)
    required(:age).value(:integer)
  end

  rule(:age) do
    key.failure("must be greater than 18") if value < 18
  end
end

validator = SignupValidator.new

result = validator.call(email: "user@hanamirb.test", age: 37)
result.success? # => true

result = validator.call(email: "user@hanamirb.test", age: "foo")
result.success? # => false
result.errors.to_h # => {:age=>["must be an integer"]}

result = validator.call(email: "user@hanamirb.test", age: 17)
puts result.success? # => false
puts result.errors.to_h # => {:age=>["must be greater than 18"]}
```

See more examples in the [`README`](https://github.com/hanami/validations/blob/unstable/README.md) and [`dry-validation` documentation](https://dry-rb.org/gems/dry-validation/)

The old `Hanami::Validation` mixin is still present for backwards compatibility.

## Compatibility 🔙

The reason why we anticipated the release of `hanami-validations` `v2.0.0.alpha1` is for **compatibility reasons**.

Because of [Semantic Versioning](https://semver.org/) reasons, Hanami 1.x depends indirectly on outdated versions of both DRY & ROM gems.
There is a huge demand to use latest DRY & ROM gems with Hanami 1.x, and `hanami-validations` `1.3` was a blocker.

With [today's release](/blog/2019/07/26/announcing-hanami-132.html) of `hanami` `v1.3.2` **it's possible to use latest DRY & ROM versions**.

## How to upgrade ⬆

Edit the `Gemfile` of your Hanami 1 application:

```ruby
gem "hanami-validations", "~> 2.0.alpha"
gem "hanami",             "~> 1.3"
```

Then run:

```shell
$ bundle update hanami hanami-validations
```

Now you'll need to update the syntax of your validations, including action params.

If you want to see a **working example of Hanami 1 + DRY 1 + ROM 5**, please check: [https://github.com/jodosha/orders](https://github.com/jodosha/orders).

## Implications 👓

Please remember that using `hanami-validations` `v2.0.0.alpha1` with `hanami` `~> 1.3` is **completely optional**.
It's just a way to let you to use latest DRY & ROM gems, **only if needed**.

If you decide to upgrade, you already have the validators ready for Hanami 2.

You can also decide to **use ROM 5 with Hanami 1 of today**.

## What's next? ⏰

We were aiming to release a new Hanami alpha version in April 2019. We apologize if we didn't make it.
We had both private life & technical difficulties that prevented us to met our goals. Thanks for understading.💚

The new alpha version will be released during the **Fall of 2019**.

Happy coding! 🌸
