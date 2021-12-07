---
title: Announcing Hanami v2.0.0.alpha4
date: 2021-12-07 13:15:19 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  New API for Content Security Policy, Router helpers from actions, CLI enhancements.
---

Hello Hanami community! We're thrilled to announce the release of Hanami 2.0.0.alpha4!

With this new cycle of monthly based releases we have smaller set of changes, but delivered more frequently.

Specifically, we're focusing on the cleanup of our application template.
The template is essential for **you** to try Hanami 2, but also for **us** to shape the ergonomics of the framework.

  * Content Security Policy (new API)
  * Router helpers to be accessible from actions
  * CLI enhancements

## Content Security Policy

We proudly share this story: Hanami was **the first Ruby framework** to ship with [Content Security Policy (CSP)](https://en.wikipedia.org/wiki/Content_Security_Policy) support.

In Hanami 1 the public API to handle CSP was less than optimal.
You had to deal with a string blob, with all the complexity of CSP keys and their values.
That was error prone and – frankly – ugly to see.

Let's start from the last concern: **you won't see CSP setting in newly generated Hanami 2 applications**.
Hanami has now defaults shipped with the framework that doesn't require to be generated with the apps.
First problem solved. 😎

If you need to change a value, or turn off the feature, the [API is simplified](https://github.com/hanami/controller/pull/353).

```ruby
module MyApp
  class Application < Hanami::Application
    # This line will generate the following CSP fragment
    # script-src 'self' https://my.cdn.test;

    config.actions.content_security_policy[:script_src] += " https://my.cdn.test"
  end
end
```

```ruby
module MyApp
  class Application < Hanami::Application
    config.actions.content_security_policy = false
  end
end
```

Second problem solved. ✌️

## Router Helpers

Router helpers are now accessible from actions as `routes`.
It exposes two methods: `url` for absolute URLs and `path` for relative ones.

It accepts a `Symbol` that corresponds to the named route (e.g. `:book`) and a set of arbitrary arguments to interpolate the route variables (e.g. `:id`).

```ruby
# frozen_string_literal: true

require "hanami/application/routes"

module AppPrototype
  class Routes < Hanami::Application::Routes
    define do
      slice :admin, at: "/admin" do
        get "/book/:id" to: "book.show", as: :book
      end
    end
  end
end
```

```ruby
module Admin
  module Actions
    module Books
      class Update < Admin::Action
        def handle(*, res)
          # update the book

          res.redirect_to routes.url(:book, id: book.id)
        end
      end
    end
  end
end
```

## CLI enhancements

Minor enhancements for the command line:

  * Display a custom prompt when using IRB based console (consistent with PRY based console)
  * Support `postgresql://` URL schemes (in addition to existing `postgres://` support) for `db` subcommands
  * Ensure slice helper methods work in console (e.g. top-level `main` method will return `Main::Slice` if an app has a "main" slice defined)

## What’s included?

Today we’re releasing the following gems:

- `hanami` v2.0.0.alpha4
- `hanami-controller` v2.0.0.alpha4
- `hanami-cli` v2.0.0.alpha4

## How can I try it?

You can check out our [Hanami 2 application template](https://github.com/hanami/hanami-2-application-template), which is up to date for this latest release and ready for you to use out as the starting point for your own app.

We’d really love for you to give the tires a good kick for this release in this particular: the more real-world testing we can have of our code loading changes, the better!

## What’s coming next?

Thank you as ever for your support of Hanami! We can’t wait to hear from you about this release, and we’re looking forward to checking in with you again next month. 🙇🏻‍♂️🌸
