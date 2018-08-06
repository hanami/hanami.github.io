---
title: Guides - Rake Tasks
version: 1.2
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
  The <code>:test</code> (or <code>:spec</code> in case you generated the application with <code>--test=rspec</code> switch) Rake task is the default.
</p>

## Ruby Server Hosting Ecosystem Compatibility

Many Software as a Service (SaaS) of the Ruby server hosting ecosystem are modeled after Ruby on Rails.
For instance, Heroku expects to find the following Rake tasks in a Ruby application:

  * `db:migrate`
  * `assets:precompile`

For Heroku, there isn't a way to customize the deploy, so we're supporting these "standard" Rake tasks from Ruby on Rails.

**If you are in control of your deployment, don't rely on these Rake tasks, but please use `hanami` [command line](/guides/1.2/command-line/database), instead.**

## Custom rake tasks

If you want to create a custom rake tasks you can create a `rakelib` folder in project root:

```
% mkdir rakelib/
```

And after that create `*.rake` file, `export.rake` for example:

```ruby
# in rakelib/export.rake

namespace :export do
  desc 'Export books to algolia service'
  task :books do
    ExportInteractor.new.call
  end
end
```

Now you can see your custom rake task in the list:

```
% bundle exec rake -T
rake export:books  # Export books to algolia service
rake environment   # Load the full project
rake spec          # Run RSpec code examples
