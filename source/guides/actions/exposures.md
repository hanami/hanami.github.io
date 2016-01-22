---
title: Hanami - Guides - Action Exposures
---

# Exposures

For complex use cases we may want to pass data to views in order to present it to our users.
Hanami puts emphasis on explicitness: data isn't shared between the controller action and the view unless we tell it to do so.

We use a simple and powerful mechanism to achieve our goal: _**exposures**_.
Exposures create a _getter_ on the action for the given name(s) and only the whitelisted instance variables are made available to the corresponding view.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action
    expose :greeting

    def call(params)
      @greeting = "Hello"
      @foo      = 23
    end
  end
end
```

In the example above we have exposed `:greeting`, but not `:foo`.
Only `greeting` can be used from the view and template.

```ruby
# apps/web/views/dashboard/index.rb
module Web::Views::Dashboard
  class Index
    include Web::View

    def welcome_message
      greeting + " and welcome"
    end
  end
end
```

If we try to use `foo`, Ruby will raise a `NoMethodError`.
