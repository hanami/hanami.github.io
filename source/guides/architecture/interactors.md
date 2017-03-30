---
title: Architecture - Interactors
---

# Overview
Hanami provides an **optional** tool for organizing your code.

These are *Interactors*, also referred to as *service objects* or *operations*

We provide `Hanami::Interactor`,
but you can use Plain Old Ruby Objects or a different library.

# A new feature: User Sign-Up
We want to add users to our `bookshelf` application.

Note: this is just to explain `Hanami::Interactor` and
we will not be building a full authentication system.
We are _only_ concerning ourselves with signing up,
not logging in or any other features.

This is a good example of functionality to extract into an Interactor,
because user sign-up is not trivial.


# Background
Passwords should **never** be stored in plain-text.

We should first _hash_ the password.
This is a function that always returns the same random output for the
same input.
It is _one-way_,
which means it's extremely hard to reverse it,
that is, to get the password from the hashed output.
(This output is called a digest.)

We don't store plain-text passwords because if our database is compromised,
we don't want to reveal our users' passwords
(since many people re-use passwords).

Instead, attackers would only get the hashed results.

Note: this approach is still vulnerable to
[Rainbow tables](https://en.wikipedia.org/wiki/Rainbow_table).

In order to combat this, we'll use a hashing scheme that employs a
[`salt`](https://en.wikipedia.org/wiki/Salt_(cryptography)).

# Preparing
Let's say we have our `bookshelf` application,
from the [Getting Started]((/guides/getting-started)
and we want to add a feature.

Clone the `bookshelf` application so we're starting from the same place.
```bash
git clone git@github.com:hanami/bookshelf.git hanami-bookshelf
cd hanami-bookshelf
bundle install
HANAMI_ENV=development hanami db prepare
HANAMI_ENV=test hanami db prepare
bundle exec rake # All the tests should pass
```

# Adding User model
```bash
hanami generate model User
```

You'll see an entity (`User`) and a repository (`UserRepository`) created,
as well as their tests files.

You'll also see a migration was generated,
something like:
`db/migrations/20170326152126_create_users.rb`

Edit this file:

```ruby
Hanami::Model.migration do
  change do
    create_table :users do
      primary_key :id
      string :email, null: false, unique: true
      string :password_digest

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
```

We'll add three columns:
- `email`, we require this field, and make sure it's unique
- `password_digest`, this will be the user's hashed password


Let's create that table:

```bash
bundle exec hanami db prepare
```

# Interactor
Let's create a place for our Interactor to go:

```bash
mkdir lib/bookshelf/interactors
mkdir spec/bookshelf/interactors
```

We put them in `lib/bookshelf` because they're decoupled from the web:
later you may want to allow users to sign up via an API or an admin portal.


Let's add some boilerplate to a new `lib/bookshelf/interactors/sign_up_user.rb` file:

```ruby
require 'hanami/interactor'

class SignUpUser
  include Hanami::Interactor

  def initialize

  end

  def call

  end
end
```

These are the only two public methods this class has:
`initialize`, to set-up the data, and
`call` to actually perform the operation(s).


Likewise, we need to fill out a new spec: `spec/bookshelf/interactors/sign_up_user_spec.rb`

```ruby
require 'spec_helper'

describe SignUpUser do
  it "succeeds" do
    interactor.call.success?.must_equal true
  end
end
```

And let's run this test:

```bash
bundle exec rake
```

All tests should pass!

Now, let's make our `SignUpUser` actually do something!

# Creating a User


Edit `spec/bookshelf/interactors/sign_up_user_spec.rb`:
```ruby
require 'spec_helper'

describe SignUpUser do
  let(:interactor) { SignUpUser.new(email: "test@example.com") }

  it "succeeds" do
    interactor.call.success?.must_equal true
  end

  it "creates a User with correct email" do
    interactor.call.user.email.must_equal "test@example.com"
  end
end
```

If you run the tests with `bundle exec rake`, you'll see this error:
```ruby
NoMethodError: undefined method `user' for #<Hanami::Interactor::Result:0x007f94498c1718>
```


```ruby
require 'hanami/interactor'

class SignUpUser
  include Hanami::Interactor

  expose :user

  def initialize(params)
    @params = params
  end

  def call
    @user = User.new(@params)
  end
end
```

There are a few things to talk about here:

The `expose :user` line exposes the `@user` instance variable as a method on the result that will be returned.

The initializer takes all the params passed in and assigns them to an instance variable,
so they can be used in `call`.

The `call` method assigns a new User entity to the `@user` variable, which will be exposed to the result.

The tests should pass now.

# Persisting the user
We have a `User` built from the params passed in,
but doesn't exist in the database yet.

```ruby
require 'spec_helper'

describe SignUpUser do
  let(:interactor) { SignUpUser.new(email: "test@example.com") }

  it "succeeds" do
    interactor.call.success?.must_equal true
  end

  it "creates a User with email" do
    interactor.call.user.email.must_equal "test@example.com"
  end

  it "persists the User" do
    interactor.call.user.id.wont_be_nil
  end
end
```

If you run the tests,
you'll the new test fails with `Expected nil to not be nil.`

This is because our unpersisted `User` does not have an `id` yet.
To add an `id`, we'll need to create a _persisted_ `User` instead.

Edit the `call` method in our `lib/bookshelf/interactors/sign_up_user.rb` Interactor:

```ruby
  def call
    @user = UserRepository.new.create(@params)
  end
```

Instead of calling `User.new`,
we create a new `UserRepository` and call `create` on it with our params.

This still returns a `User`, but it also persists this record to the database.

If you run the tests now you'll see... a few errors.
`Hanami::Model::UniqueConstraintViolationError: SQLite3::ConstraintException: UNIQUE constraint failed: users.email`

This is because our test file calls `interactor.call` three times,
so the interactor tries to create three `User`s with the same email address.
We told our database `email` should be unique though.

Luckily, this is simple fix.
We just need to clean up the database before we run each test.

Edit `spec/bookshelf/interactors/sign_up_user_spec.rb`:
```ruby
require 'spec_helper'

describe SignUpUser do
  let(:interactor) { SignUpUser.new(email: "test@example.com") }

  before { UserRepository.new.clear }

  # ...
end
```

And now all our tests should pass!


# Password Hashing
We're going to hash our passwords with `bcrypt`.

This is a secure industry standard,
and luckily there's [a Ruby wrapper](https://github.com/codahale/bcrypt-ruby) for it!

This is not a security guide,
but... _please_ do not implement your own hashing scheme,
nor use MD5 or any SHA-based hashing function for password hashing.

BCrypt includes a salt (so you don't have to worry about that)
and includes key-stretching, which makes them harder to crack.

Let's ensure the `User` has a password_digest:
```ruby
describe SignUpUser do
  # ...

  it "creates a User with password_digest" do
    result.user.password_digest.length.must_equal 60
  end
end
```

BCrypt outputs a digest that's 60 characters long, so we check for that.

Our test will fail because `password_digest` isn't assigned.

## BCrypt
First, we need to add `bcrypt` to our Gemfile:
```ruby
gem 'bcrypt'
```

Then run `bundle install` to install it.


In order to make our test pass,
we need to add the `password_digest` to our Interactor.

```ruby
  # ...

  def call
    @user = UserRepository.new.create(
      email: @params[:email],
      password_digest: BCrypt::Password.create(@params[:password])
    )
  end
```

This will store a cryptographically secure digest of the user's password.

# Error handling
What if a user legitimately tries to create an account for an email that already has an account?
As we saw before, a `Hanami::Model::UniqueConstraintViolationError` will be raised.

This is fine,
but we want to handle this error within the Interactor,
rather than leaking this implementation detail throughout the rest of our program.

```ruby
  # ...

  it "fails for violating unique constraint on email" do
    interactor.call
    result = interactor.call
    result.failure?.must_equal true
    result.errors.must_equal ["The email test@example.com is already signed up"]
  end
```

Running this test will cause an error, because
`Hanami::Model::UniqueConstraintViolationError` will be raised.


Let's fix our Interactor to rescue from that error:
```ruby
  def call
    @user = UserRepository.new.create(
      email: @params[:email],
      password_digest: BCrypt::Password.create(@params[:password])
    )
  rescue Hanami::Model::UniqueConstraintViolationError
    error! "The email #{@params[:email]} is already signed up"
  end
```

This `error!` method adds a message to an `errors` array available on the result,
and it also makes sure `.success?` will return false
(and vice-versa, `.failure?` will return true)

Now our tests will pass!

# Controller Actions
[To be completed]

# Summary/Rationale/Conclusion
[To be completed]
