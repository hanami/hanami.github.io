---
title: Guides - Logging
version: 1.0
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

## Not logging request params

If you want to disable logging of the request params completely, it can be
easily achieved with custom formatter:

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
