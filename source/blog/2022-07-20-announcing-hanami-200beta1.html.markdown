---
title: Announcing Hanami v2.0.0.beta1
date: 2022-07-20 11:04:32 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Hanami 2 first beta: app centric revolution & CLI. What to expect in 2.0 and 2.1.
---

Hello Hanami community! We're thrilled to announce the release of Hanami 2.0.0.beta1!

## App Centric Revolution

We revolutionized Hanami apps: **`app/` directory is the primary home for your code.**

For those who remember about **_slices_**, they **are now optional**.
What's a slice? You may ask.
Think of _slices_ as software modules of your application.
A typical use case is to use a _slice_ to implement a business domain (e.g. billing, accounting, admin).

So far, this was the only way to build Hanami apps: use _slices_ to build several domains of your app.
But that approach was able to serve only the building of a _monolith_.
We wanted to let you to build small services with Hanami as well, without the code ceremony of the slices.

Let's dissect a newly generated application:

- `app/` is home for your application code
- `app/actions` hosts your actions and `app/action.rb` (`Bookshelf::Action`) is the superclass for them
- `config/app.rb` defines your application (`Bookshelf::App`) and its configuration
- `config/settings.rb` defines your settings such as the database URL
- `config/routes.rb` defines your application HTTP routes
- `lib/` is home for your code that doesn't depend directly on Hanami framework
- `lib/bookshelf/types.rb` defines your custom Ruby data types (based on dry-types gem)
- `lib/tasks` is there to host custom Rake tasks
- `spec/` contains testing code (based on RSpec)
- `spec/requests` hosts HTTP integration tests (based on rack-test gem)

```
⚡ tree .
.
├── Gemfile
├── Gemfile.lock
├── README.md
├── Rakefile
├── app
│   ├── action.rb
│   └── actions
├── config
│   ├── app.rb
│   ├── routes.rb
│   └── settings.rb
├── config.ru
├── lib
│   ├── bookshelf
│   │   └── types.rb
│   └── tasks
└── spec
    ├── requests
    │   └── root_spec.rb
    ├── spec_helper.rb
    └── support
        ├── requests.rb
        └── rspec.rb

9 directories, 14 files
```

**Simple. In the spirit of Hanami.**

## CLI

This first beta comes with new CLI commands:

- `hanami new` to generate a new application
- `hanami server` to start the HTTP server (Puma)
- `hanami routes` to print application routes

Remember, `hanami --help`, is your friend 😉.

## Hanami 2.0 & 2.1

Some of you may have noticed in the previous section we didn't mention views.
Where are views?

We want to release Hanami 2 stable as soon as possible.
We decided to split the remaining scope in Hanami 2.0 and 2.1.

### Hanami 2.0

The roadmap until 2.0 is straightforward: solidify the app structure presented today.
We plan to add more commands to CLI code generators, support code reloading, and write documentation.

That's it!

This way you can learn Hanami 2 by building apps (hint API apps, the router it's really fast).

### Hanami 2.1

For this release, things will look complete from a full stack web framework perspective.

Hanami apps will support views, helpers, assets, and persistence (based on ROM).

## What’s included?

Today we’re releasing the following gems:

- `hanami` v2.0.0.beta1
- `hanami-cli` v2.0.0.beta1
- `hanami-rspec` v3.11.0.beta1 (it follows RSpec versioning)
- `hanami-controller` v2.0.0.beta1
- `hanami-router` v2.0.0.beta1
- `hanami-validations` v2.0.0.beta1
- `hanami-utils` v2.0.0.beta1

## How can I try it?

```
⚡ gem install hanami --pre
⚡ hanami new bookshelf
⚡ cd bookshelf
⚡ bundle exec hanami --help
```

## Thank You

Thank you as always for supporting Hanami!
We can’t wait to hear from you about this release, and we’re looking forward to checking in with you again soon. 🌸
