---
title: Lotus - Guides - Action Parameters
---

# Action Parameters

Parameters are taken from the Rack env and passed as an argument to `#call`.
They are similar to a Ruby Hash, but they offer an expanded set of features.

## Sources

Params can come from:

  * [Router variables](/guides/routing/basic-usage) (eg. `/books/:id`)
  * Query string (eg. `/books?title=Lotus`)
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

### Indifferent Access

Until the version 2.2.0 of MRI (Matz Ruby Interpreter), symbols weren't garbage collected.
Because params come from untrusted sources (the web), we cannot automatically symbolize their keys.
This is a security mechanism to avoid an attack called _Symbol DoS_.

Params are stored internally with string keys, but they offer a convenient access for symbols too.

```ruby
params[:q]
# or
params['q']
```

<p class="warning">
  Indifferent Access may be removed future versions of Lotus in favor of symbol access only.
</p>

### Nested Access

Params offer indifferent access to for nested values.

```ruby
params[:book][:title]
# or
params['book']['title']
```

Now, what happens if the parameter `:book` is missing in our current request?
Because `params[:book]` is `nil`, we can't access `:title`.
In this case Ruby will raise a `NoMethodError`.

We have a safe solution for our problem: `#get`.
It accepts a **dot separated** string, where each token represents a level in our nested structure.

```ruby
params.get('book.title')           # => "Lotus"
params.get('unknown.nested.param') # => nil instead of NoMethodError
```

## Whitelisting

In order to show how whitelisting works, let's create a new action:

```shell
bundle exec lotus generate action web signup#create
```

We want to provide self-registration for our users.
We build an HTML form and this is the action that accepts the payload and stores it in the `users` table.
That table has a boolean column `admin` to decide if a person has administration permissions.

A malicious user can exploit this scenario, by sending this extra parameter to our application and become an admin.

We can easily fix this problem, by filtering the allowed params that can comes inside our application.
Please always remember that **params represent untrusted input**.

We use `.params` to map the structure of the (nested) params.

```ruby
# apps/web/controllers/signup/create.rb
module Web::Controllers::Signup
  class Create
    include Web::Action

    params do
      param :email
      param :password

      param :address do
        param :country
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
But in the long term, this approach is painful from a maintenance perspective.

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

We can see validations the set of rules for data correctness that we want for **a specific use case**.
For us, an `User` can be persisted with or without a password, **depending on the workflow** that the it was routed into.

### Boundaries

The second important aspect is that we use validations to prevent invalid inputs to propagate in our system.
In an MVC architecture, the model layer is the **farthest** from the input.
It's expensive to check the data right before we create a record in the database.

If we **consider correct data as a precondition** before to start our workflow, we should stop unacceptable inputs as soon as possible.

Think of the following method.
We don't want to continue if the data is invalid for us.

```ruby
def expensive_computation(argument)
  return if argument.nil?
  # ...
end
```

### Usage

We can coerce the Ruby type, validate if a param is required, if included in range of values, etc..

```ruby
# apps/web/controllers/signup/create.rb
module Web::Controllers::Signup
  class Create
    include Web::Action
    MEGABYTE = 1024 ** 2

    params do
      param :name,             presence: true
      param :email,            presence: true, format: /@/, confirmation: true
      param :password,         presence: true,              confirmation: true
      param :terms_of_service, acceptance: true
      param :avatar,           size: 0..(MEGABYTE * 3)
      param :age,              type: Integer, size: 18..99
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

Params validations are delegated under the hood to [Lotus::Validations](https://github.com/lotus/validations).
Please check related docs for a complete list of options, and how to share code between validations.

## Concrete Classes

The params DSL is really quick and intuitive but it has the drawback that it can be visually noisy and makes it hard to unit test them.
An alternative usage is to extract a class and pass it as an argument to `.params`.

```ruby
# apps/web/controllers/signup/my_params.rb
module Web::Controllers::Signup
  class MyParams < Web::Action::Params
    MEGABYTE = 1024 ** 2

    param :name,             presence: true
    param :email,            presence: true, format: /@/, confirmation: true
    param :password,         presence: true,              confirmation: true
    param :terms_of_service, acceptance: true
    param :avatar,           size: 0..(MEGABYTE * 3)
    param :age,              type: Integer, size: 18..99
  end
end
```

```
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
