---
title: Guides - Use Your Own ORM
---

# Use Your Own ORM

Hanami components are decoupled each other.
This level of separation allows you to use the ORM (data layer) of your choice.

Here's how to do it:

  1. Edit your `Gemfile`, remove `hanami-model`, add the gem(s) of your ORM and run `bundle install`.
  2. Remove `lib/` directory (eg. `rm -rf`).
  3. Edit `config/environment.rb` and remove any reference to `lib/`.

Please notice that if `hanami-model` is removed from the project features like [database commands](/guides/command-line/database) and [migrations](/guides/migrations/overview) aren't available.

