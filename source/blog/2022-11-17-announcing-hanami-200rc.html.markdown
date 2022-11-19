---
title: "Hanami 2.0: Awesome Short Summary Here"
date: 2022-11-17 08:24:53 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  TODO blah blah
---

After more than three years of work, Hanami 2.0 is here! This release marks a new era for Hanami, and presents a revolutionary new vision for Ruby applications!

Hanami 2.0 is jam packed with goodies:

- An **advanced new application core** offering advanced code loading capabilities
- An **always-there dependencies mixin**, helping you draw clearer connections between your app's components
- A **blazing fast new router**
- Redesigned **functional action classes** that integrate seamlessly with your app's business logic
- **Type-safe app settings** with dotenv integration, ensuring your app has everything it needs in every environment
- New **providers** for flexibly managing the lifecycle of your app's critical components and integrations
- New built-in **slices** for gradual modularisation as your app grows
- A **rewritten getting started guide** to help you get going with all of the above

To build Hanami 2.0, we’ve brought together with the [dry-rb][dry-rb] and [rom-rb][rom-rb] teams, and together we’re very proud to present BLAH BLAH brought together the best of all of these libraries and provide you with a curated, easy-to-start experience.

With 2.0 Hanami apps are no longer just for the web: Hanami is now **the everything framework** for Rubyists. By removing just a few lines from your `Gemfile`, you can have everything you need and nothing you don’t. Remove the router and controller, for example, and you can build a chatbot or a Kafka consumer and still take advantage of all the other conveniences of Hanami.

There’s a lot here, and we can’t wait for you to try it out. Let’s take a look at the highlights in more detail.

## Advanced application core

At the heart of every Hanami 2.0 app is an advanced code loading system. It all begins when you run `hanami new` and have your app defined in `config/app.rb`:

```ruby
require "hanami"

module MyApp
  class App < Hanami::App
  end
end
```

From here you can build your app's logic in `app/`, and then boot the app, which loads all your code, as part of running a web server. This is the usual story.

In Hanami 2.0, your app can do so much more. You can use the app object itself to load and return any individual component:

```ruby
# Return an instance of the action in app/actions/home/show.rb

Hanami.app["actions.home.show"] # => #<MyApp::Actions::Home::Show>
```

You can also choose to _prepare_ rather than fully boot your app. This loads the minimal set of files required for your app to load individual components on demand. This is how the Hanami console launches, and how your app is prepared for running unit tests.

This means your experience interacting with your app remains as snappy as possible even as it grows to many hundreds or thousands of components. Your hanami console will always load in milliseconds, and your unit tests will keep you squarely in the TDD flow.

## Always-there dependencies mixin

No class is an island.

## Blazing fast new router

## Functional action classes

## Type-safe app settings

## Providers

## Slices

## Getting started guide

## What’s next

Hanami 2.1 in Q1 of 2023, including database persistence, views, and assets. Full stack is just around the corner.
