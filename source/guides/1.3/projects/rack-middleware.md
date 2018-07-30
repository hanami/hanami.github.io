---
title: Guides - Rack Middleware
version: 1.2
---

# Rack Middleware

Hanami exposes a project level [Rack middleware stack](http://www.rubydoc.info/github/rack/rack/master/file/SPEC) to be configured like this:

```ruby
# config/environment.rb
Hanami.configure do
  middleware.use MyRackMiddleware
end
```

It's worth noticing that this is equivalent to add a middleware in `config.ru` file.
The only difference is that third-party plugins can hook into `Hanami.configure` to inject their own middleware.
