---
title: Guides - Rake Tasks
---

# Rake Tasks

Hanami ships with default Rake tasks that can be used as _prerequisites_ by developers to build their own tasks.

```shell
% bundle exec rake -T
rake environment # Load the full project
rake test        # Run tests (for Minitest)
rake spec        # Run tests (for RSpec)
```

## Environment

Use this as a Rake task prerequisite when we need to access project code (eg. entities, actions, views, etc..)

### Example

Imagine we want to build a Rake task that is able to access project code (eg. a repository)

```ruby
# Rakefile

task clear_users: :environment do
  UserRepository.new.clear
end
```

```shell
bundle exec rake clear_users
```

## Test / Spec

This is the default Rake task, which runs the test suite

The following commands are equivalent:

```shell
% bundle exec rake
```

```shell
% bundle exec rake test
```

<p class="convention">
  The <code>:test</code> (or <code>:spec</code>) Rake task is the default.
</p>

## Ruby Server Hosting Ecosystem Compatibility

Many Software as a Service (SaaS) of the Ruby server hosting ecosystem are modeled after Ruby on Rails.
For instance, Heroku expects to find the following Rake tasks in a Ruby application:

  * `db:migrate`
  * `assets:precompile`

For Heroku, there isn't a way to customize the deploy, so we're supporting these "standard" Rake tasks from Ruby on Rails.

**If you are in control of your deployment, don't rely on these Rake tasks, but please use `hanami` [command line](/guides/head/command-line/database), instead.**
