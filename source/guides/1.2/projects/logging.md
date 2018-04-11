---
title: Guides - Logging
version: 1.2
---

# Logging

Each project has a global logger available at `Hanami.logger` that can be used like this: `Hanami.logger.debug "Hello"`

It can be configured in `config/environment.rb`

```ruby
# config/environment.rb
# ...

Hanami.configure do
  # ...

  environment :development do
    logger level: :info
  end

  environment :production do
    logger level: :info, formatter: :json

    # ...
  end
end
```

By default it uses standard output because it's a [best practice](http://12factor.net/logs) that most hosting SaaS companies [suggest using](https://devcenter.heroku.com/articles/rails4#logging-and-assets).

If you want to use a file, pass `stream: 'path/to/file.log'` as an option.

## Filter sensitive informations

Hanami automatically logs the body of non-GET HTTP requests.

When a user submits a form, all the fields and their values will appear in the log:

```shell
[bookshelf] [INFO] [2017-08-11 18:17:54 +0200] HTTP/1.1 POST 302 ::1 /signup 5 {"signup"=>{"username"=>"jodosha", "password"=>"secret", "password_confirmation"=>"secret", "bio"=>"lorem"}} 0.00593
```

To avoid sensitive informations to be logged, you can filter them:

```ruby
# config/environment.rb
# ...

Hanami.configure do
  # ...
  environment :development do
    logger level: :debug, filter: %w[password password_confirmation]
  end
end
```

Now the output will be:

```shell
[bookshelf] [INFO] [2017-08-11 18:17:54 +0200] HTTP/1.1 POST 302 ::1 /signup 5 {"signup"=>{"username"=>"jodosha", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]", "bio"=>"lorem"}} 0.00593
```

It also supports fine grained patterns to disambiguate params with the same name.
For instance, we have a billing form with street number and credit card number, and we want only to filter the credit card:

```ruby
# config/environment.rb
# ...

Hanami.configure do
  # ...
  environment :development do
    logger level: :debug, filter: %w[credit_card.number]
  end
end
```

```shell
[bookshelf] [INFO] [2017-08-11 18:43:04 +0200] HTTP/1.1 PATCH 200 ::1 /billing 2 {"billing"=>{"name"=>"Luca", "address"=>{"street"=>"Centocelle", "number"=>"23", "city"=>"Rome"}, "credit_card"=>{"number"=>"[FILTERED]"}}} 0.009782
```

Note that `billing => address => number` wasn't filtered while `billing => credit_card => number` was filtered instead.

If you want to disable logging of the body completely, it can be easily achieved
with custom formatter:

```ruby
class NoParamsFormatter < ::Hanami::Logger::Formatter
  def _format(hash)
    hash.delete :params
    super hash
  end
end
```

and than just telling logger to use our new formatter for logging

```ruby
logger level: :debug, formatter: NoParamsFormatter.new
```

## Arbitrary Arguments

You can speficy [arbitrary arguments](https://ruby-doc.org/stdlib/libdoc/logger/rdoc/Logger.html#class-Logger-label-How+to+create+a+logger), that are compatible with Ruby's `Logger`.

Here's how to setup daily log rotation:

```ruby
# config/environment.rb
# ...

Hanami.configure do
  # ...

  environment :production do
    logger 'daily', level: :info, formatter: :json, stream: 'log/production.log'

    # ...
  end
end
```

Alternatively, you can decide to put a limit to the number of files (let's say `10`) and the size of each file (eg `1,024,000` bytes, aka `1` megabyte):

```ruby
# config/environment.rb
# ...

Hanami.configure do
  # ...

  environment :production do
    logger 10, 1_024_000, level: :info, formatter: :json, stream: 'log/production.log'

    # ...
  end
end
```

## Automatic Logging

All HTTP requests, SQL queries, and database operations are automatically logged.

When a project is used in development mode, the logging format is human readable:

```ruby
[bookshelf] [INFO] [2017-02-11 15:42:48 +0100] HTTP/1.1 GET 200 127.0.0.1 /books/1  451 0.018576
[bookshelf] [INFO] [2017-02-11 15:42:48 +0100] (0.000381s) SELECT "id", "title", "created_at", "updated_at" FROM "books" WHERE ("book"."id" = '1') ORDER BY "books"."id"
```

For production environment, the default format is JSON.
JSON is parseable and more machine-oriented. It works great with log aggregators or SaaS logging products.

```json
{"app":"bookshelf","severity":"INFO","time":"2017-02-10T22:31:51Z","http":"HTTP/1.1","verb":"GET","status":"200","ip":"127.0.0.1","path":"/books/1","query":"","length":"451","elapsed":0.000391478}
```

## Custom Loggers

You can specify a custom logger in cases where you desire different logging behaviour. For example,
the [Timber logger](https://github.com/timberio/timber-ruby):

```ruby
# config/environment.rb
# ...

Hanami.configure do
  # ...

  environment :production do
    logger Timber::Logger.new(STDOUT)

    # ...
  end
end
```

Use this logger as normal via `Hanami.logger`. It's important to note that any logger chosen
must conform to the default `::Logger` interface.

## Colorization

### Disable colorization

In order to disable the colorization:

```ruby
# config/environment.rb
# ...

Hanami.configure do
  # ...

  environment :development do
    logger level: :info, colorizer: false
  end
end
```

### Custom colorizer

You can build your own colorization strategy

```ruby
# config/environment.rb
# ...
require_relative "./logger_colorizer"

Hanami.configure do
  # ...

  environment :development do
    logger level: :info, colorizer: LoggerColorizer.new
  end
end
```

```ruby
# config/logger_colorizer.rb
require "hanami/logger"
require "paint" # gem install paint

class LoggerColorizer < Hanami::Logger::Colorizer
  def initialize(colors: { app: [:red, :bright], severity: [:red, :blue], datetime: [:italic, :yellow] })
    super
  end

  private

  def colorize(message, color:)
    Paint[message, *color]
  end
end
```
