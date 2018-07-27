---
title: Guides - Action Parameters
version: 1.2
---

# Parameters

Parameters are taken from the Rack env and passed as an argument to `#call`.
They are similar to a Ruby Hash, but they offer an expanded set of features.

## Sources

Params can come from:

  * [Router variables](/guides/1.2/routing/basic-usage) (eg. `/books/:id`)
  * Query string (eg. `/books?title=Hanami`)
  * Request body (eg. a `POST` request to `/books`)

## Access

To access the value of a param, we can use the _subscriber operator_ `#[]`.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
      self.body = "Query string: #{ params[:q] }"
    end
  end
end
```

If we visit `/dashboard?q=foo`, we should see `Query string: foo`.

### Symbol Access

Params and nested params can be referenced **only** via symbols.

```ruby
params[:q]
params[:book][:title]
```

Now, what happens if the parameter `:book` is missing from the request?
Because `params[:book]` is `nil`, we can't access `:title`.
In this case Ruby will raise a `NoMethodError`.

We have a safe solution for our problem: `#get`.
It accepts a list of symbols, where each symbol represents a level in our nested structure.

```ruby
params.get(:book, :title)             # => "Hanami"
params.get(:unknown, :nested, :param) # => nil instead of NoMethodError
```

## Whitelisting

In order to show how whitelisting works, let's create a new action:

```shell
bundle exec hanami generate action web signup#create
```

We want to provide self-registration for our users.
We build a HTML form which posts to an action that accepts the payload and stores it in the `users` table.
That table has a boolean column `admin` to indicate whether a person has administration permissions.

A malicious user can exploit this scenario by sending this extra parameter to our application, thereby making themselves an administrator.

We can easily fix this problem by filtering the allowed parameters that are permitted inside our application.
Please always remember that **params represent untrusted input**.

We use `.params` to map the structure of the (nested) parameters.

```ruby
# apps/web/controllers/signup/create.rb
module Web::Controllers::Signup
  class Create
    include Web::Action

    params do
      required(:email).filled
      required(:password).filled

      required(:address).schema do
        required(:country).filled
      end
    end

    def call(params)
      puts params[:email]             # => "alice@example.org"
      puts params[:password]          # => "secret"
      puts params[:address][:country] # => "Italy"

      puts params[:admin]             # => nil
    end
  end
end
```

Even if `admin` is sent inside the body of the request, it isn't accessible from `params`.

## Validations & Coercion

### Use Cases

In our example (called _"Signup"_), we want to make `password` a required param.

Imagine we introduce a second feature: _"Invitations"_.
An existing user can ask someone to join.
Because the invitee will decide a password later on, we want to persist that `User` record without that value.

If we put `password` validation in `User`, we need to handle these two use cases with a conditional.
But in the long term this approach is painful from a maintenance perspective.

```ruby
# Example of poor style for validations
class User
  attribute :password, presence: { if: :password_required? }

  private
  def password_required?
     !invited_user? && !admin_password_reset?
  end
end
```

We can see validations as the set of rules for data correctness that we want for **a specific use case**.
For us, a `User` can be persisted with or without a password, **depending on the workflow** and the route through
which the `User` is persisted.

### Boundaries

The second important aspect is that we use validations to prevent invalid inputs to propagate in our system.
In an MVC architecture, the model layer is the **farthest** from the input.
It's expensive to check the data right before we create a record in the database.

If we **consider correct data as a precondition** before starting our workflow, we should stop unacceptable inputs as soon as possible.

Think of the following method.
We don't want to continue if the data is invalid.

```ruby
def expensive_computation(argument)
  return if argument.nil?
  # ...
end
```

### Usage

We can coerce the Ruby type, validate if a param is required, determine if it is within a range of values, etc..

```ruby
# apps/web/controllers/signup/create.rb
module Web::Controllers::Signup
  class Create
    include Web::Action
    MEGABYTE = 1024 ** 2

    params do
      required(:name).filled(:str?)
      required(:email).filled(:str?, format?: /@/).confirmation
      required(:password).filled(:str?).confirmation
      required(:terms_of_service).filled(:bool?)
      required(:age).filled(:int?, included_in?: 18..99)
      optional(:avatar).filled(size?: 1..(MEGABYTE * 3))
    end

    def call(params)
      if params.valid?
        # ...
      else
        # ...
      end
    end
  end
end
```

Parameter validations are delegated, under the hood, to [Hanami::Validations](https://github.com/hanami/validations).
Please check the related documentation for a complete list of options and how to share code between validations.

## Concrete Classes

The params DSL is really quick and intuitive but it has the drawback that it can be visually noisy and makes it hard to unit test.
An alternative is to extract a class and pass it as an argument to `.params`.

```ruby
# apps/web/controllers/signup/my_params.rb
module Web::Controllers::Signup
  class MyParams < Web::Action::Params
    MEGABYTE = 1024 ** 2

    params do
      required(:name).filled(:str?)
      required(:email).filled(:str?, format?: /@/).confirmation
      required(:password).filled(:str?).confirmation
      required(:terms_of_service).filled(:bool?)
      required(:age).filled(:int?, included_in?: 18..99)
      optional(:avatar).filled(size?: 1..(MEGABYTE * 3)
    end
  end
end
```

```ruby
# apps/web/controllers/signup/create.rb
require_relative './my_params'

module Web::Controllers::Signup
  class Create
    include Web::Action
    params MyParams

    def call(params)
      if params.valid?
        # ...
      else
        # ...
      end
    end
  end
end
```

### Inline predicates

In case there is a predicate that is needed only for the current params, you can define inline predicates:

```ruby
module Web::Controllers::Books
  class Create
    include Web::Action

    params Class.new(Hanami::Action::Params) {
      predicate(:cool?, message: "is not cool") do |current|
        current.match(/cool/)
      end

      validations do
        required(:book).schema do
          required(:title) { filled? & str? & cool? }
        end
      end
    }

    def call(params)
      if params.valid?
        self.body = 'OK'
      else
        self.body = params.error_messages.join("\n")
      end
    end
  end
end
```

## Body Parsers

Rack ignores request bodies unless they come from a form submission.
If we have a JSON endpoint, the payload isn't available in `params`.

```ruby
module Web::Controllers::Books
  class Create
    include Web::Action
    accept :json

    def call(params)
      puts params.to_h # => {}
    end
  end
end
```

```shell
curl http://localhost:2300/books      \
  -H "Content-Type: application/json" \
  -H "Accept: application/json"       \
  -d '{"book":{"title":"Hanami"}}'    \
  -X POST
```

In order to make book payload available in `params`, we should enable this feature:

```ruby
# apps/web/application.rb
module Web
  class Application < Hanami::Application
    configure do
      # ...
      body_parsers :json
    end
  end
end
```

Now `params.get(:book, :title)` returns `"Hanami"`.

In case there is no suitable body parser for your format in Hanami, it is possible to declare a new one:

```ruby
# lib/foo_parser.rb
class FooParser
  def mime_types
    ['application/foo']
  end
  
  def parse(body)
    # manually parse body
  end
end
```

and subsequently register it:

```ruby
# apps/web/application.rb
# ...
module Web
  class Application < Hanami::Application
    configure do
      # ...
      body_parsers FooParser.new
      # ...
    end
  end
end
```
