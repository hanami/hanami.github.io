---
title: Guides - Action Share Code
version: 1.0
---

# Share Code

Actions as objects have a lot of advantages but they make code sharing less intuitive.
This section shares a few techniques to make this possible.

## Prepare

In our settings (`apps/web/application.rb`), there is a code block that allows us to share the code for **all the actions** of our application.
When an action includes the `Web::Action` module, that block code is yielded within the context of that class.
This is heavily inspired by Ruby Module and its `included` hook.

Imagine we want to check if the current request comes from an authenticated user.

We craft a module in `apps/web/controllers/authentication.rb`.

```ruby
# apps/web/controllers/authentication.rb
module Web
  module Authentication
    def self.included(action)
      action.class_eval do
        before :authenticate!
        expose :current_user
      end
    end

    private

    def authenticate!
      halt 401 unless authenticated?
    end

    def authenticated?
      !!current_user
    end

    def current_user
      @current_user ||= UserRepository.new.find(session[:user_id])
    end
  end
end
```

Once included by an action, it will set a [before callback](/guides/actions/control-flow) that executes `:authenticate!` for each request.
If not logged in, a `401` is returned, otherwise the flow can go ahead and hit `#call`.
It also exposes `current_user` for all the views (see [Exposures](/guides/actions/exposures)).

It will be really tedious to include this module for all the actions of our app.
We can use `controller.prepare` for the scope.

```ruby
# apps/web/application.rb
require_relative './controllers/authentication'

module Web
  class Application < Hanami::Application
    configure do
      controller.prepare do
        include Web::Authentication
      end
    end
  end
end
```

<p class="warning">
Code included via <code>prepare</code> is available for ALL the actions of an application.
</p>

### Skipping A Callback

Let's say we have included `Authentication` globally, but want to skip the execution of its callback for certain resources.
A typical use case is to redirect unauthenticated requests to our sign in form.

The solution is really simple and elegant at the same time: override that method.

```ruby
# apps/web/controllers/sessions/new.rb
module Web::Controllers::Sessions
  class New
    include Web::Action

    def call(params)
      # ...
    end

    private
    def authenticate!
      # no-op
    end
  end
end
```

The action will still try to invoke `:authenticate!`, because, technically speaking, **callbacks execution can't be skipped**.
But if we override that method with an empty implementation, it does nothing and our non-signedin users can reach the wanted resource.

## Module Inclusion

Imagine we have a RESTful resource named `books`.
There are several actions (`show`, `edit`, `update` and `destroy`) which need to find a specific book to perform their job.

What if we want to DRY the code of all these actions?
Ruby comes to our rescue.

```ruby
# apps/web/controllers/books/set_book.rb
module Web::Controllers::Books
  module SetBook
    def self.included(action)
      action.class_eval do
        before :set_book
      end
    end

    private

    def set_book
      @book = BookRepository.new.find(params[:id])
      halt 404 if @book.nil?
    end
  end
end
```

We have defined a module for our behavior to share. Let's include it in all the actions that need it.

```ruby
# apps/web/controllers/books/update.rb
require_relative './set_book'

module Web::Controllers::Books
  class Update
    include Web::Action
    include SetBook

    def call(params)
      # ...
    end
  end
end
```

