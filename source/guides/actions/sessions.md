---
title: Lotus - Guides - Action Sessions
---

# Sessions

## Enable Sessions

Sessions are available in Lotus applications, but not enabled by default.
If we want to turn on this feature, we just need to uncomment a line of code.

```ruby
# apps/web/application.rb
module Web
  class Application < Lotus::Application
    configure do
      # ...
      sessions :cookie, secret: ENV['WEB_SESSIONS_SECRET']
    end
  end
end
```

The first argument is the name of the adapter for the session storage.
The default value is `:cookie`, that uses `Rack::Session::Cookie`.

<p class="convention">
The name of the session adapter is the underscored version of the class name under <code>Rack::Session</code> namespace.
Example: <code>:cookie</code> for <code>Rack::Session::Cookie</code>.
</p>

We can use a different storage compatible with Rack sessions.
Let's say we want to use Redis. We should bundle `redis-rack` and specify the name of the adapter: `:redis`.
Lotus is able to autoload the adapter and use it when the application is started.

<p class="convention">
Custom storage technologies are autoloaded via <code>require "rack/session/#{ adapter_name }"</code>.
</p>

The second argument passed to `sessions` is a Hash of options that are **passed to the adapter**.
We find only a default `:secret`, but we can specify all the values that are supported by the current adapter.

## Usage

Sessions behave like a Hash: we can read, assign and remove values.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
      session[:b]         # read
      session[:a] = 'foo' # assign
      session[:c] = nil   # remove
    end
  end
end
```
