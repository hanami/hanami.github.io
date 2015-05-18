---
title: Lotus - Guides - Action Exception Handling
---

# Exception Handling

Actions have an elegant API for exception handling.
The behavior changes according to the current Lotus environment and to the custom settings in our configuration.

## Default Behavior

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
      raise 'boom'
    end
  end
end
```

Exceptions are automatically caught when in production mode, but not in development.
In the first case, for our example, the application returns a `500` (Internal Server Error), in the latter case, we'll see the stack trace and all the informations to debug the code.

This behavior can be changed with `handle_exceptions` setting in `apps/web/application.rb`.

## Custom HTTP Status

If we want to map an exception to a specific HTTP status code, we can use `handle_exception` DSL.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action
    handle_exception ArgumentError => 400

    def call(params)
      raise ArgumentError
    end
  end
end
```

It accepts a Hash where the key is the exception to handle, and the value is the corresponding HTTP status code.
In our example, when `ArgumentError` is raised, it will be handled as a `400` (Bad Request).

## Custom Handlers

If the mapping with a custom HTTP status doesn't fit our need, we can specify a custom handler and manage the exception by ourselves.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class PermissionDenied < StandardError
    def initialize(role)
      super "You must be admin, but you are: #{ role }"
    end
  end

  class Index
    include Web::Action
    handle_exception PermissionDenied => :handle_permission_error

    def call(params)
      unless current_user.admin?
        raise PermissionDenied.new(current_user.role)
      end

      # ...
    end

    private
    def handle_permission_error(exception)
      status 403, exception.message
    end
  end
end
```

If we specify a symbol as value for `handle_exception`, it will be used to manage the exception.
In our case we want to protect the action from unwanted access: only admins are allowed.

When a `PermissionDenied` exception is raised, it will be handled by `:handle_permission_error`.
It MUST accept a `exception` argument.
That is the exception instance raised inside `#call`.

<p class="warning">
When specify custom exception handler, it MUST accept an <code>exception</code> argument.
</p>
