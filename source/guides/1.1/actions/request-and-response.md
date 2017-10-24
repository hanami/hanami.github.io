---
title: Guides - Request & Response
version: 1.1
---

# Request

In order to access the metadata coming from a HTTP request, an action has a private object `request` that derives from `Rack::Request`.
Here an example of some information that we can introspect.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
      puts request.path_info      # => "/dashboard"
      puts request.request_method # => "GET"
      puts request.get?           # => true
      puts request.post?          # => false
      puts request.xhr?           # => false
      puts request.referer        # => "http://example.com/"
      puts request.user_agent     # => "Mozilla/5.0 Macintosh; ..."
      puts request.ip             # => "127.0.0.1"
    end
  end
end
```

<p class="warning">
  Instantiating a <code>request</code> for each incoming HTTP request can lead to minor performance degradation.
  As an alternative, please consider getting the same information from private action methods like <code>accept?</code> or from the raw Rack environment <code>params.env</code>.
</p>

# Response

The implicit return value of `#call` is a serialized `Rack::Response` (see [#finish](http://rubydoc.info/github/rack/rack/master/Rack/Response#finish-instance_method)):

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
    end
  end
end

# It will return [200, {}, [""]]
```

It has private accessors to explicitly set status, headers and body:

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
      self.status = 201
      self.body   = 'Your resource has been created'
      self.headers.merge!({ 'X-Custom' => 'OK' })
    end
  end
end

# It will return [201, { "X-Custom" => "OK" }, ["Your resource has been created"]]
```

As shortcut we can use `#status`.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
      status 201, "Your resource has been created"
    end
  end
end

# It will return [201, {}, ["Your resource has been created"]]
