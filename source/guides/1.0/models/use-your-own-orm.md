---
title: Guides - Use Your Own ORM
version: 1.0
---

# Use Your Own ORM

Hanami components are decoupled from each other.
This level of separation allows you to use the ORM (data layer) of your choice.

Here's how to do it:

1. Edit your `Gemfile`:
    - Remove `hanami-model`.
    - Add the gem(s) for your ORM.
2. Run `bundle install`.
3. Remove folders that are no longer needed:
    - Remove `lib/project_name/entities/` and `lib/projectname/repositories/`
    - Remove `spec/project_name/entities/` and `spec/project_name/repositories/`.
5. Edit `config/environment.rb`:
    - Remove `require 'hanami/model'`
    - Remove `require_relative '../lib/projectname'`
    - Remove `model` block in `Hanami.configure`
6. Edit `Rakefile`:
    - Remove `require 'hanami/rake_tasks'`.

In general, `lib/project_name/` is a good place to put code that's used across
apps, so we don't recommend getting rid of it entirely. That's also where
Hanami's mailers live. We recommend that you put your new ORM code into that
folder, but you're free to put it elsewhere, and get rid of `lib/` entirely, if
you choose.

Please notice that if `hanami-model` is removed from the project features like [database commands](/guides/1.0/command-line/database) and [migrations](/guides/1.0/migrations/overview) aren't available.
