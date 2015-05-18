---
title: Lotus - Guides - Action Control Flow
---

# Control Flow

Using exceptions for control flow is expensive for Ruby VM.
There is a lightweight alternative that our language supports: **signals** (see `throw` and `catch`).

## Halt

Lotus take advantage of this mechanism to provide **faster control flow** in our actions via `#halt`.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
      halt 401 unless authenticated?
      # ...
    end

    private
    def authenticated?
      # ...
    end
  end
end
```

When used, this API **interrupts the flow**, and returns the control to the framework.
Subsequent instructions will be entirely skipped.

<p class="warning">
When <code>halt</code> is used, the flow is interrupted and the control is passed back to the framework.
</p>

That means it can be used to skip `#call` invokation entirely if we use it in a `before` callback.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action
    before :authenticate!

    def call(params)
      # ...
    end

    private
    def authenticate!
      halt 401 if current_user.nil?
    end
  end
end
```

`#halt` accepts a HTTP status code as first argument.
When used like this, the body of the response will be set with the corresponding message (eg. "Unauthorized" for `401`).

An optional second argument can be passed to set a custom body.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
      halt 404, "These aren't the droids you're looking for"
    end
  end
end
```

## Redirect

A special case of control flow management is relative to HTTP redirect.
If we want to reroute a request to another resource we can use `redirect_to`.

After it's invoked, it stops the control flow, and **subsequent lines aren't executed**.

It accepts a string that represents an URI, and an optional `:status` argument.
By default the status is set to `302`.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
      redirect_to routes.root_path
      # This line will never be executed
    end
  end
end
```
