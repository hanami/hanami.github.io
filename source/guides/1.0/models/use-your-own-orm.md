---
title: Guides - Use Your Own ORM
version: 1.0
---

# Use Your Own ORM

Hanami components are decoupled each other.
This level of separation allows you to use the ORM (data layer) of your choice.

Here's how to do it:

  1. Edit your `Gemfile`, remove `hanami-model`, add the gem(s) of your ORM and run `bundle install`.
  2. Remove `lib/` directory (eg. `rm -rf lib`). Either keep `lib/bookshelf/mailers` or also remove `mailer` block in step 3.
  3. Open `config/environment.rb`, then remove `require 'hanami/model'`, `require_relative '../lib/bookshelf'` (`bookshelf` should be name of your project) and `model` block in `Hanami.configure`
  4. Open `Rakefile` and remove `require 'hanami/rake_tasks'`.

Please notice that if `hanami-model` is removed from the project features like [database commands](/guides/1.0/command-line/database) and [migrations](/guides/1.0/migrations/overview) aren't available.
