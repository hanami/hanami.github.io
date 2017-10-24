---
title: Guides - Actions Basic Usage
version: 1.1
---

# Basic Usage

## Requests Handling

In the [previous section](/guides/1.1/actions/overview), we generated an action.  Now let's use it.

First, we check our routes:

```ruby
# apps/web/config/routes.rb
get '/dashboard', to: 'dashboard#index'
```

### View Rendering

Then we edit the corresponding template:

```erb
# apps/web/templates/dashboard/index.html.erb
<h1>Dashboard</h1>
```

Here is how Hanami handles an incoming request:

  1. The router creates a new instance of `Web::Controllers::Dashboard::Index` and invokes `#call`.
  2. The application creates a new instance of `Web::Views::Dashboard::Index` and invokes `#render`.
  3. The application returns the response to the browser.

<p class="convention">
  For a given action named <code>Web::Controllers::Dashboard::Index</code>, a corresponding view MUST be present: <code>Web::Views::Dashboard::Index</code>.
</p>

If we visit `/dashboard` we should see `<h1>Dashboard</h1>` in our browser.

### Bypass Rendering

By default an action takes care of the HTTP status code and response header, but not of the body of the response.
As seen above, it delegates the corresponding view to render and set this value.

Sometimes we want to bypass this process.
For instance we want to return a simple body like `OK`.
To involve a view in this case is a waste of CPU cycles.

If we set the body of the response from an action, **our application will ignore the view**.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
      self.body = 'OK'
    end
  end
end
```

Here is how Hanami handles an incoming request in this case:

  1. The router creates a new instance of `Web::Controllers::Dashboard::Index` and invokes `#call`.
  2. The application detects that a body is already set and doesn't instantiate the view.
  3. The application returns the response to the browser.

If we visit `/dashboard` again, now we should see `OK`.

<p class="convention">
  If the response body was already set by an action, the rendering process is bypassed.
</p>

With direct body assignment, **we can safely delete the corresponding view and template**.

## Initialization

Actions are instantiated for us by Hanami at the runtime: for each incoming request, we'll automatically get a new instance.
Because actions are objects, **we can take control on their initialization** and eventually [_inject_ our dependencies](http://en.wikipedia.org/wiki/Dependency_injection).
This is a really useful technique for unit testing our actions.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def initialize(greeting: Greeting.new)
      @greeting = greeting
    end

    def call(params)
      self.body = @greeting.message
    end
  end
end
```

There is a limitation that we should always be kept in mind:

<p class="warning">
  Action initializer MUST have an arity of 0.
</p>

The following initializers are valid:

```ruby
# no arguments
def initialize
  # ...
end

# default arguments
def initialize(greeting = Greeting.new)
  # ...
end

# keyword arguments
def initialize(greeting: Greeting.new)
  # ...
end

# options
def initialize(options = {})
  # ...
end

# options
def initialize(**options)
  # ...
end

# splat arguments
def initialize(*args)
  # ...
end
```
