---
title: Announcing Hanami v2.0.0.beta3
date: 2022-09-21 14:17:23 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Code reloading, Puma support out of the box, routes simplification
---

Hello again, friends! We’re excited to share our release of Hanami 2.0.0.beta3!

## Code Reloading

Hanami server and console now support code reloading.

New apps are generated with `hanami-reloader` in `Gemfile` and with a new `Guardfile`.
Code reloading for `hanami server` is based on `guard`.
When the file system changes because of code edits, Guard restarts the Hanami server.

In Hanami 1, we achieved code reloading with an "inside-the-framework" approach that turned to be problematic.
With `hanami-reloader`, we implemented this "outside-the-framework" that has positive implications:

- File system watching is delegated to Guard
- Hanami is now free from code reloading awareness
- Not bundling `hanami-reloader` (e.g. in production), eliminates automatically the code reloading logic
- With `zeitwerk` and `dry-container` we achieved lazy boot of the app, resulting in **very fast code reloading**.

Regarding the Hanami console, we reintroduced `reload` command to be invoked from the console to reload its context.

## Puma

New apps are generated with `puma` in `Gemfile` and with `config/puma.rb` configuration.

## Routes simplification

The routes definition in `config/routes.rb` looks simpler with the elimination of `define` wrapper.

**Before**

```ruby
# frozen_string_literal: true

module Bookshelf
  class Routes < Hanami::Routes
    define do
      root { "Hello from Hanami" }
    end
  end
end
```

**After**

```ruby
# frozen_string_literal: true

module Bookshelf
  class Routes < Hanami::Routes
    root { "Hello from Hanami" }
  end
end
```

## What’s included?

Today we’re releasing the following gems:

- `hanami` v2.0.0.beta3
- `hanami-rspec` v3.11.0.beta3 (it follows RSpec’s versioning)
- `hanami-cli` v2.0.0.beta3
- `hanami-reloader` v1.0.0.beta3

For specific changes from the last beta release, please see each gem’s own CHANGELOG.

## How can I try it?

```
⚡ gem install hanami --pre
⚡ hanami new bookshelf
⚡ cd bookshelf
⚡ bundle exec hanami --help
```

## Contributors

Thank you to these fine people for contributing to this release!

- [Luca Guidi](https://github.com/jodosha)
- [Marc Busqué](https://github.com/waiting-for-dev)
- [Tim Riley](https://github.com/timriley)
- [Piotr Solnica](https://github.com/solnic)

## Thank you

Thank you as always for supporting Hanami!

We can’t wait to hear from you about this release, and we’re looking forward to checking in with you again soon. 🌸
