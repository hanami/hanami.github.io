---
title: Lotus - Guides - Action Control Flow
---

# Control Flow

## Callbacks

If we want to execute some logic before and/or after `#call` is executed, we can use a callback.
Callbacks are useful to declutter code for common tasks like checking if a user is signed in, set a record, handle 404 responses or tidy up the response.

The correspoding DSL methods are `before` and `after`.
These methods each accept a symbol that is the name of the method that we want to call, or an anonymous proc.

### Methods

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action
    before :track_remote_ip

    def call(params)
      # ...
    end

    private
    def track_remote_ip
      @remote_ip = request.ip
      # ...
    end
  end
end
```

With the code above, we are tracking the remote IP address for analytics purposes.
Because it isn't strictly related to our business logic, we move it to a callback.

A callback method can optionally accept an argument: `params`.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action
    before :validate_params

    def call(params)
      # ...
    end

    private
    def validate_params(params)
      # ...
    end
  end
end
```

### Proc

The examples above can be rewritten with anonymous procs.
They are bound to the instance context of the action.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action
    before { @remote_ip = request.ip }

    def call(params)
      # @remote_ip is available here
      # ...
    end
  end
end
```

A callback proc can bound an optional argument: `params`.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action
    before {|params| params.valid? }

    def call(params)
      # ...
    end
  end
end
```

<p class="warning">
Don't use callbacks for model domain logic operations like sending emails.
This is an antipattern that causes a lot of problems for code maintenance, testability and accidental side effects.
</p>

## Halt

Using exceptions for control flow is expensive for the Ruby VM.
There is a lightweight alternative that our language supports: **signals** (see `throw` and `catch`).

Lotus takes advantage of this mechanism to provide **faster control flow** in our actions via `#halt`.

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

That means that `halt` can be used to skip `#call` invokation entirely if we use it in a `before` callback.

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

`#halt` accepts an HTTP status code as the first argument.
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

When `redirect_to` is invoked, control flow is stopped and **subsequent code in the action is not executed**.

It accepts a string that represents an URI, and an optional `:status` argument.
By default the status is set to `302`.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
      redirect_to routes.root_path
      foo('bar') # This line will never be executed
    end
  end
end
```
