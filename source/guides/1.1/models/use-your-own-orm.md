---
title: Guides - Use Your Own ORM
version: 1.1
---

# Use Your Own ORM

Hanami components are decoupled each other.
This level of separation allows you to use the ORM (data layer) of your choice.

Here's how to do it:

1. Edit your `Gemfile`:
    1. Remove `hanami-model`
    1. Add the gem(s) of your ORM
1. Run `bundle install`.
1. If you want to keep the mailer code:
    1. Remove the `lib/projectname/entities` and `lib/projectname/repositories` directories.  (Don't erase `lib/projectname/mailers`.)
1. If you don't want to keep the mailer code:
    1. Remove the `lib/` directory (eg. `rm -rf lib`).
1. Remove the corresponding directories (`entities`, `repositories`; and also `mailers` if you're not keeping the mailers) from the `spec/` directory.
1. Open `config/environment.rb`, then:
    1. remove `require 'hanami/model'`
    1. remove `require_relative '../lib/projectname'`
    1. remove `model` block in `Hanami.configure`
    1. if not keeping the mailers, then remove the `mailer` block, too.
1. Open `Rakefile` and remove `require 'hanami/rake_tasks'`.

Please notice that if `hanami-model` is removed from the project features like [database commands](/guides/1.1/command-line/database) and [migrations](/guides/1.1/migrations/overview) won't be available.
