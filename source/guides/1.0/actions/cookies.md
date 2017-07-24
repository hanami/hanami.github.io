---
title: Guides - Action Cookies
version: 1.0
---

# Cookies

## Enable Cookies

Hanami applies _"batteries included, but not installed"_ philosophy.
Cookies are a feature that is present but needs to be activated.

In our application settings there is a line to uncomment.

```ruby
# apps/web/application.rb
module Web
  class Application < Hanami::Application
    configure do
      # ...
      cookies true
    end
  end
end
```

From now on, cookies are automatically sent for each response.

### Settings

With that configuration we can specify options that will be set for all cookies we send from our application.

  * `:domain` - `String` (`nil` by default), the domain
  * `:path` - `String` (`nil` by default), a relative URL
  * `:max_age` - `Integer` (`nil` by default), cookie duration expressed in seconds
  * `:secure` - `Boolean` (`true` by default if using SSL), restrict cookies to secure connections
  * `:httponly` - `Boolean` (`true` by default), restrict JavaScript access to cookies

## Usage

Cookies behave like a Hash: we can read, assign and remove values.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
      cookies[:b]         # read
      cookies[:a] = 'foo' # assign
      cookies[:c] = nil   # remove
    end
  end
end
```

When setting a value, a cookie can accept a `String` or a `Hash` to specify inline options.
General settings are applied automatically but these options can be used to override values case by case.

### Example

```ruby
# apps/web/application.rb
module Web
  class Application < Hanami::Application
    configure do
      # ...
      cookies max_age: 300 # 5 minutes
    end
  end
end
```

We're going to set two cookies from the action: the first will inherit application configuration, while the second overrides the default value.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
      # Set-Cookie:a=foo; max-age=300; HttpOnly
      cookies[:a] = 'foo'

      # Set-Cookie:b=bar; max-age=100; HttpOnly
      cookies[:b] = { value: 'bar', max_age: 100 }
    end
  end
end
```
