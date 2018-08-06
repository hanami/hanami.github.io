---
title: Guides - Action MIME Types
version: 1.2
---

# MIME Types

Actions have advanced features for MIME type detection, automatic headers, whitelisting etc..

## Request Introspection

In order to understand what the requested MIME type is, an action looks at the `Accept` request header and exposes a high level API: `#format` and `#accept?`.

The first returns a symbol representation of the MIME type (eg. `:html`, `:json`, `:xml` etc..), while the second is a query method that accepts a MIME type string and checks if it's accepted by the current browser.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
      puts format                     # => :html

      puts accept?('text/html')       # => true
      puts accept?('application/png') # => false
    end
  end
end
```

## Automatic Content-Type

An action returns the `Content-Type` response header automatically according to the requested MIME Type and charset.

If the client asks for `Accept: text/html,application/xhtml+xml,application/xml;q=0.9`, the action will return `Content-Type: text/html; charset=utf-8`.

### Default Request Format

If a client asks for a generic `Accept: */*`, the action will fall back to the **application default format**.
This is a setting that allows us to safely handle cases like our example; the default value is `:html`.

```ruby
# apps/web/application.rb

module Web
  class Application < Hanami::Application
    configure do
      # ...
      default_request_format :json
    end
  end
end
```

### Default Response Format

If we are building a JSON API app, it can be useful to specify a `:json` as default MIME Type for the response.
The default value is `:html`.

```ruby
# apps/web/application.rb

module Web
  class Application < Hanami::Application
    configure do
      # ...
      default_response_format :json
    end
  end
end
```

### Default Charset

Similarly, we can specify a different default charset to return.
The standard value is `utf-8`, but we can change it in our settings.

```ruby
# apps/web/application.rb

module Web
  class Application < Hanami::Application
    configure do
      # ...
      default_charset 'koi8-r'
    end
  end
end
```

### Override

There is a way we can force the returned `Content-Type`: use `#format=`.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
      puts self.format # => :html

      # force a different value
      self.format        =  :json
      puts self.format # => :json
    end
  end
end
```

The example above will return `Content-Type: application/json; charset=utf-8`.

## Whitelisting

We can also restrict the range of accepted MIME Types.
If the incoming request doesn't satisfy this constraint, the application will return a `Not Acceptable` status (`406`).

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action
    accept :html, :json

    def call(params)
      # ...
    end
  end
end
```

## Register MIME Types

Hanami knows about more than 100 of the most common MIME types.
However, we may want to add custom types in order to use them with `#format=` or `.accept`.

In our application settings we can use `controller.format`, which accepts a Hash where the key is the format symbol (`:custom`) and the value is a string expressed in the MIME type standard (`application/custom`).

```ruby
# apps/web/application.rb

module Web
  class Application < Hanami::Application
    configure do
      # ...
      controller.format custom: 'application/custom'
    end
  end
end
```
