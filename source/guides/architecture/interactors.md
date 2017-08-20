---
title: Architecture - Interactors
---

# Overview
Hanami provides an **optional** tool for organizing your code.

These are *Interactors*,
also referred to *service objects*, *use-cases* or *operations*

In this guide, we'll explain how they work by adding a small feature to an existing application.

The existing application we'll work from is the `bookshelf` application
from the [Getting Started Guide]((/guides/getting-started).

# A new feature: email notifications
Whenever a book is added to our `bookshelf` application,
we want to send an email out notifying the admininstrators of the site.

This is just an example to show when you should use an interactor, and,
specifically, how `Hanami::Interactor` can be used.

You could extend this example to add administrator approval of new books,
or allowing editing via a link.

In practice,
you can use `Interactors` to implement any business logic.
It's particularly useful for when you want to do several things at once,
in order to manage the complexity of the codebase.

# Callbacks? We Don't Need No Stinkin' Callbacks!
A common method of implementing email notification would be to add a callback.
That is: whenever a new record is created in the database,
an email is sent out.

By design, Hanami doesn't provide any such mechanism.
This is because it's persistence callbacks are an **anti-pattern**.
They violate the Single-Responsibility principle,
by conflating persistence with email notifications.

During testing (and at some other point, most likely),
you'll want to skip that callback.
This quickly becomes confusing when you want to skip several callbacks.
They make code hard to understand, and brittle.

Instead, we recommend being **explicit over implicit**.

An interactor is an object that represents a specific *use-case*.

They let each class have a single responsibility.
Interactors' single responsibility is to call other behavior.

We provide `Hanami::Interactor` as a module,
so you can start with a Plain Old Ruby Object (no superclass),
and then `include Hanami::Interactor` when you need some of its features.

TODO: Add note about alternative libraries?

# Concept
The central idea behind Interactors is that you extract an isolated piece of functionality into a new class.

There's a minimal interface,
with just two methods called on Interactors: `#new` and `#call`.

This lets you easily test just that specific behavior,
rather than having it be expressed implicitly elsewhere.

This helps manage complexity: making it visible and able to be named.

# Preparing
Let's say we have our `bookshelf` application,
from the [Getting Started]((/guides/getting-started)
and we want to add a feature.

Clone the `bookshelf` application so we're starting from the same place.
```shell
% git clone git@github.com:hanami/bookshelf.git hanami-bookshelf
% cd hanami-bookshelf
% bundle install
% HANAMI_ENV=development hanami db prepare
% HANAMI_ENV=test hanami db prepare
% bundle exec rake # All the tests should pass
```

```shell
% bundle exec hanami db prepare
```

# Interactor
Let's create a place for our Interactor to go:

```shell
% mkdir lib/bookshelf/interactors
% mkdir spec/bookshelf/interactors
```
We put them in `lib/bookshelf` because they're decoupled from the web:
later you may want to add books via an admin portal, or an API.

Let's call our interactor `AddBook`,
and write a new spec `spec/bookshelf/interactors/add_book_spec.rb`:

```ruby
require 'spec_helper'

describe Addbook do
  let(:interactor) { AddBook.new }

  it "succeeds" do
    interactor.call.success?.must_equal true
  end
end
```

Running your test suite will cause a NameError because there is no `AddBook` class.
Let's create that class in a `lib/bookshelf/interactors/add_book.rb` file:

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

These are the only two public methods this class should ever have:
`initialize`, to set-up the data, and
`call` to actually perform the operation(s).

These methods are free to call private methods that you'll write.

By default, the operation is considered a success,
since we didn't say that it failed.

Let's run this test:

```shell
% bundle exec rake
```

All the tests should pass!

Now, let's make our `AddBook` actually do something!


# Creating a Book

Edit `spec/bookshelf/interactors/add_book_spec.rb`:
```ruby
require 'spec_helper'

describe AddBook do
  let(:interactor) { AddBook.new }

  describe "good input" do
    let(:result) { interactor.call(attributes) }

    it "succeeds" do
      result.success?.must_equal true
    end

    it "creates a Book with correct title and author" do
      result.book.title.must_equal "The Fire Next Time"
      result.book.author.must_equal "James Baldwin"
    end
  end
end
```

If you run the tests with `bundle exec rake`, you'll see this error:
```ruby
NoMethodError: undefined method `book' for #<Hanami::Interactor::Result:0x007f94498c1718>
```

Let's fill out our Interactor,
then explain what we did:

```ruby
require 'hanami/interactor'

class AddBook
  include Hanami::Interactor

  expose :book

  def initialize

  end

  def call(params)
    @book = Book.new(params)
  end
end
```

There are a few things to talk about here:

The `expose :book` line exposes the `@book` instance variable as a method on the result that will be returned.

The `call` method assigns a new Book entity to the `@book` variable, which will be exposed to the result.

The tests should pass now.

# Persisting the book
We have a new `book` built from the title and author passed in,
but it doesn't exist in the database yet.

We need to use a `BookRepository` to persist it.

```ruby
require 'spec_helper'

describe SignUpUser do
  let(:interactor) { SignUpUser.new(email: "test@example.com") }

  it "succeeds" do
    interactor.call.success?.must_equal true
  end

  it "creates a Book with correct title and author" do
    result.book.title.must_equal "The Fire Next Time"
    result.book.author.must_equal "James Baldwin"
  end

  it "persists the Book" do
    result.book.id.wont_be_nil
  end
end
```

If you run the tests,
you'll see the new expectation fails with `Expected nil to not be nil.`

This is because the book we built is unpersisted;
it only gets an `id` once it exists in the database.

To make this test pass, we'll need to create a _persisted_ `Book` instead.

Edit the `call` method in our `lib/bookshelf/interactors/ad_book.rb` Interactor:

```ruby
  def call
    @book = BookRepository.new.create({title: title, author: author})
  end
```

Instead of calling `Book.new`,
we create a new `BookRepository` and send `create` to it, with our attributes.

This still returns a `Book`, but it also persists this record to the database.

If you run the tests now you'll see all the tests pass.


# Email notification
Let's add the email notification!

You can use a different library,
but we'll use `Hanami::Mailer`.
(You can do anything here,
like send an SMS, send a chat message, or call a webhook.)

```shell
% bundle exec hanami generate mailer book_added_notification
      create  lib/bookshelf/mailers/book_added_notification.rb
      create  spec/bookshelf/mailers/book_added_notification_spec.rb
      create  lib/bookshelf/mailers/templates/book_added_notification.txt.erb
      create  lib/bookshelf/mailers/templates/book_added_notification.html.erb
```

We won't get into the details of [how the mailer works](/guides/mailers/overview),
but it's pretty simple: there's a `Hanami::Mailer` class, an associated spec,
and two templates (one for plaintext, and one for html).

Since we're keeping things simple,
let's delete the `html` email template.
Plaintext will be fine.

```shell
% rm lib/bookshelf/mailers/templates/book_added_notification.html.erb
```

TODO: finish this! test for mailer, and calling it from interactor

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

# Validations

Validations should be placed as close to user input as possible.
The reason for this is that different use-cases can have different validations
(for example, admin validation might be less strict than normal user's validations).
In a web application, this means putting them in your controller actions.

However,
there are times when you might want to put the validations at a lower-level.
This lets you share them across the use-cases and
ensures consistent behavior from different applications.

Here's how you do that.

`Hanami::Interactor` has built-in support for simple validations.
If the validations (via a private `valid?` method) fail,
then `call` is never run and the result is `failure`, rather than `success.

Let's say we want to prohibit any password that begins with the string `password`:
so `password`, `passwordabc`, `password123` would all be prohibited.
In a real app,
you may want to do robust password strength checking,
but this an adequate example for our purposes.


```ruby
require 'spec_helper'

describe SignUpUser do
  # ...

  it "fails for having password as 'password'" do
    result = SignUpUser.new(email: "test@example.com", password: "password").call
    result.failure?.must_equal [ ]
  end

  it "fails for having password as 'password123'" do
    result = SignUpUser.new(email: "test@example.com", password: "password123").call
    result.failure?.must_equal true
    result.errors.must_equal [ ]
  end
end
```

These two tests will fail,
because `valid?` is inherited from `Hanami::Interactor`,
which returns `true` by default.

Let's override that method in our interactor:
```ruby
require 'hanami/interactor'

class SignUpUser
  include Hanami::Interactor

  # ...

  private

  def valid?
    @params[:password][0..7] != "password"
  end
end
```

Now our tests should all pass.

This is fine, but we'd like to know what went wrong:
our `errors` array on the result is empty.

We can leverage `error!`
(like we used for duplicate email addresses)
to fix this.

```ruby
require 'spec_helper'

describe SignUpUser do
  # ...

  it "fails for having password as 'password'" do
    result = SignUpUser.new(email: "test@example.com", password: "password").call
    result.failure?.must_equal true
    result.errors.must_equal [
      "Please choose a password that does not contain a word on our banned list."
    ]
  end

  it "fails for having password as 'password123'" do
    result = SignUpUser.new(email: "test@example.com", password: "password123").call
    result.failure?.must_equal true
    result.errors.must_equal [
      "Please choose a password that does not contain a word on our banned list."
    ]
  end
end
```

These two tests will fail, because our `errors` array is still empty.

```ruby
require 'hanami/interactor'

class SignUpUser
  include Hanami::Interactor

  # ...

  private

  def valid?
    @params[:password][0..7] != "password" ||
    error!("Please choose a password that does not contain a word on our banned list.")
  end
end
```

Note that we inverted the equality check here,
in order to leverage boolean logic.

That is, our method now says:
it is valid if it does *not* begin with password, else it's an error.
This works with the API, because `error!` returns false.

And now our tests should pass!

# Controller Actions
[To be completed]

But, you're probably most interested in using your interactor in a Hanami web application.

To do that, let's first generate an action:

```shell
% bundle exec hanami generate action web user_registrations#create --skip-view
      create  spec/web/controllers/user_registrations/create_spec.rb
      create  apps/web/controllers/user_registrations/create.rb
      insert  apps/web/config/routes.rb
```

First, let's edit the generated spec,
`spec/web/views/user_registrations/create_spec.rb`:

```ruby
require 'spec_helper'
require_relative '../../../../apps/web/controllers/user_registrations/create'

describe Web::Controllers::UserRegistrations::Create do
  let(:action) { Web::Controllers::UserRegistrations::Create.new }
  let(:params) { Hash[] }

  before { UserRepository.new.clear }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
    response[2].must_equal ["Created!"]
  end

  it 'fails when user with same email already exists' do
    UserRepository.new.create(params)
    response = action.call(params)
    response[0].must_equal 400
    response[2].must_equal [
      "Errors: The email test@example.com is already signed up"
    ]
  end
end
```

This fails because we didn't implement the action, so let's do that:

```
module Web::Controllers::UserRegistrations
  class Create
    include Web::Action

    def call(params)
      result = SignUpUser.new(params).call

      if result.success?
        self.status = 200
        self.body = "Created!"
      else
        self.status = 400
        self.body = "Errors: #{result.errors.join(', ')}"
      end
    end
  end
end
```

This is a simple way to use interactors in your controller actions.

But, the testing can be improved.

Right now, we fell into the trap of testing an implementation detail.
The action spec should not test what happens *inside* the interactor.

Instead, we should just test that the interactor is called,
and that both successes and failures are handled.

# Summary/Rationale/Conclusion
[To be completed]

# Naming Interactors
[To be completed]

# DB Constraint? Uniqueness.
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


