---
title: Lotus - Guides - Rack Integration
---

# Rack Integration

[Lotus::Router](https://github.com/lotus/router) is compatible with [Rack SPEC](http://www.rubydoc.info/github/rack/rack/master/file/SPEC) and so the endpoints that we use MUST be compliant as well.
In the example above we use a `Proc`, where both the signature and the implementation are fitting our requirements.

A valid endpoint for Lotus::Router can be an object, a class, an action, or an **application** that responds to `#call`.

```ruby
router = Lotus::Router.new do
  get '/lotus',      to: ->(env) { [200, {}, ['Hello from Lotus!']] }
  get '/middleware', to: Middleware
  get '/rack-app',   to: RackApp.new
  get '/rails',      to: ActionControllerSubclass.action(:new)
  get '/sinatra',    to: SinatraApp.new
end
```

If we use a string, it tries to instantiate a class from it:

```ruby
class RackApp
  def call(env)
    # ...
  end
end

run Lotus::Router.new {
  get '/lotus', to: 'rack_app' # it will map to RackApp.new
}
```

It also supports Controller + Action syntax (**for Lotus::Controller compatibility**):

```ruby
module Flowers
  class Index
    def call(env)
      # ...
    end
  end
end

run Lotus::Router.new {
  get '/flowers', to: 'flowers#index' # it will map to Flowers::Index.new
}
```
