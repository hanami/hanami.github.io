---
title: "Guides - Command Line: Plugins"
version: 1.3
---

# Plugins

Hanami has a convenient way to load commands from third party gems, so if you want to add a Hanami compatible gem, you only have to add it inside your project's `Gemfile` in the **`:plugins` group**.

```ruby
# Gemfile
group :plugins do
  gem "hanami-reloader"
end
```

## Add a command

Imagine you want to build a **fictional** gem called `hanami-webpack` with a CLI command: `hanami webpack setup`.

```ruby
# lib/hanami/webpack.rb
module Hanami
  module Webpack
    module CLI
      class Setup < Hanami::CLI::Command
        def call(*)
          # setup code goes here...
        end
      end
    end
  end
end

Hanami::CLI.register "webpack setup", Hanami::Webpack::CLI::Setup
```

This code above will make the following command available:

```shell
% bundle exec hanami webpack setup
```

## Hook into existing command

Third-party Hanami plugins can hook into existing commands, in order to enhance the default behavior.
During the command execution lifecycle you can execute custom code **before** and/or **after** the command itself.

Let's say we want to build a **fictional** gem `hanami-database-analyzer`, that prints database stats after `db migrate` is ran.

```ruby
# lib/hanami/database/analizer.rb
module Hanami
  module Database
    module Analyzer
      class Stats
        def call(*)
          puts "The database has 23 tables"
        end
      end
    end
  end
end

Hanami::CLI.before("db migrate"), ->(*) { puts "I'm about to migrate database.." }
Hanami::CLI.after "db migrate", Hanami::Database::Analyzer::Stats.new
```

By running `db migrate`, the third-party code is executed:

```shell
% bundle exec hanami db migrate
I'm about to migrate database..
# ...
The database has 23 tables
```
