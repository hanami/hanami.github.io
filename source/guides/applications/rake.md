---
title: Hanami | Guides - Applications Rake Tasks
---

# Rake Tasks

Hanami ships with default Rake tasks that can be used as _prerequisites_ by developers to build their own tasks.

```shell
% bundle exec rake -T
rake environment  # Load the full project
rake preload      # Preload project configuration
rake test         # Run tests
```

## Environment

This Rake task:

  1. Executes all `preload` steps
  2. Load all the project code

Use this as a Rake task prerequisite when you **DO** need to access to project code (eg. entites, actions, views, etc..)

### Example

Imagine we want to build a Rake task that is able to access project code (eg. a repository)

```ruby
# Rakefile

task clear_users: :environment do
  UserRepository.clear
end
```

```shell
bundle exec rake clear_users
```

<p class="notice">
  The <code>:environment</code> Rake loads the entire project. It's slower than <code>:preload</code>, use it when you need to access project code.
</p>

## Preload

This Rake task is a fast way to preload:

  * Gem dependencies in `Gemfile`
  * The framework
  * Project configurations such as env variables and application configurations (eg. `apps/web/application.rb`)

Use this as a Rake task prerequisite when you **DO NOT** need to access to project code (eg. entites, actions, views, etc..)

### Example

Imagine we want to build a Rake task that prints informations about our project:

```ruby
# Rakefile

task print_informations: :preload do
  puts ENV['HANAMI_ENV']             # => "development"
  puts ENV['DATABASE_URL'] # => "postgres://localhost/bookshelf_development"
  puts defined?(User)                # => nil
end
```

```shell
% bundle exec rake print_informations
"development"
"postgres://localhost/bookshelf_development"
""
```

<p class="notice">
  The <code>:preload</code> Rake task preloads projects and applications configurations. Use it when you need a fast way to access them.
</p>

## Test

This is the default Rake task, it runs the test suite

The following commands are equivalent:

```shell
% bundle exec rake
```

```shell
% bundle exec rake test
```

<p class="convention">
  The <code>:test</code> Rake task is the default.
</p>

## Ruby Ecosystem Compatibility

Many Software as a Service (SaaS) of the Ruby ecosystem are modeled after Ruby on Rails.
For instance, Heroku expects to find the following Rake tasks in a Ruby application:

  * `db:migrate`
  * `assets:precompile`

For Heroku, there isn't a way to customize the deploy, so we're supporting these "standard" Rake tasks from Ruby on Rails.

**If you are in control of your deployment, don't rely on these Rake tasks, but please use `hanami` [command line](/guides/command-line/database), instead.**
