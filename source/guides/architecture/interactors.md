---
title: Architecture - Interactors
---

# Overview
Hanami provides an **optional** tool for organizing your code.

These are *Interactors*,
also referred to *service objects*, *use-cases* or *operations*

We think they're great and help manage complexity,
but you're free to build a Hanami app without them at all.

In this guide, we'll explain how Hanami's Interactors work by adding a small feature to an existing application.

The existing application we'll work from is the `bookshelf` application
from the [Getting Started Guide]((/guides/getting-started).

# A new feature: email notifications
The story for our new feature is:
> As an administrator, I want to receive an email notification when a book is added

Since the application doesn't have authentication, anyone can add a new book.
We'll provide an admin email address via an environment variable.

This is just an example to show when you should use an Interactor, and,
specifically, how `Hanami::Interactor` can be used.

This example could provide a basis for other features like
adding administrator approval of new books before they're posted,
or allowing users to provide an email address, then edit the book via a special link.

In practice,
you can use `Interactors` to implement *any business logic*.
It's particularly useful for when you want to do several things at once,
in order to manage the complexity of the codebase.

They're used to isolate non-trivial business logic.
This follows the [Single Responsibility Principle](https://en.wikipedia.org/wiki/Single_responsibility_principle)

In a web application, they will generally be called from the controller action.
This lets you separate concerns.
Your business logic objects, Interactors, won't know about the web at all.

# Callbacks? We Don't Need No Stinkin' Callbacks!
An easy, common method of implementing email notification would be to add a callback.

That is: after a new `Book` record is created in the database, an email is sent out.

By design, Hanami doesn't provide any such mechanism.
This is because we consider persistence callbacks an **anti-pattern**.
They violate the Single-Responsibility principle,
by conflating persistence with email notifications.

During testing (and at some other point, most likely),
you'll want to skip that callback.
This quickly becomes confusing, since multiple callbacks on the same event will
be triggered in a specific order. Also, you may want to skip several callbacks at some point.
They make code hard to understand, and brittle.

Instead, we recommend being **explicit over implicit**.

An Interactor is an object that represents a specific *use-case*.

They let each class have a single responsibility.
The Interactors' single responsibility is to do whatever is needed to achieve a
specific outcome.

We provide `Hanami::Interactor` as a module,
so you can start with a Plain Old Ruby Object (no superclass),
and then `include Hanami::Interactor` when you need some of its features.

TODO: Add note about alternative libraries?
- [collectiveidea's `interactor`](https://github.com/collectiveidea/interactor)
0 [dry-rb's `dry-transaction`](http://dry-rb.org/gems/dry-transaction/))

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
% HANAMI_ENV=test bundle exec hanami db prepare
% bundle exec rake # All the tests should pass
```

# Interactor
Let's create a place for our Interactor to go:

```shell
% mkdir lib/bookshelf/interactors
% mkdir spec/bookshelf/interactors
```
We put them in `lib/bookshelf` because they're decoupled from the web application:
later you may want to add books via an admin portal, an API, or even a command-line utility.

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

class AddBook
  include Hanami::Interactor

  def initialize
    # set up the object
  end

  def call(book_attributes)
    # perform the required behavior
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
  let(:attributes) { Hash[author: "James Baldwin", title: "The Fire Next Time"] }

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

  def call(book_attributes)
    @book = Book.new(book_attributes)
  end
end
```

There are a few things to talk about here:

The `expose :book` line exposes the `@book` instance variable as a method on the result that will be returned.

The `call` method assigns a new Book entity to the `@book` variable, which will be exposed to the result.

The tests should pass now.

We've initialized a new Book entity, but it's not persisted to the database.

# Persisting the book
We have a new `book` built from the title and author passed in,
but it doesn't exist in the database yet.

We need to use a `BookRepository` to persist it.

```ruby
require 'spec_helper'

describe AddBook do
  let(:interactor) { AddBook.new }
  let(:attributes) { Hash[author: "James Baldwin", title: "The Fire Next Time"] }

  describe "good input" do
    let(:result) { interactor.call(attributes) }

    it "succeeds" do
      result.success?.must_equal true
    end

    it "creates a Book with correct title and author" do
      result.book.title.must_equal "The Fire Next Time"
      result.book.author.must_equal "James Baldwin"
    end

    it "persists the Book" do
      result.book.id.wont_be_nil
    end
  end
end
```

If you run the tests,
you'll see the new expectation fails with `Expected nil to not be nil.`

This is because the book we built is unpersisted;
it only gets an `id` once it exists in the database.

To make this test pass, we'll need to create a _persisted_ `Book` instead.

Edit the `call` method in our `lib/bookshelf/interactors/add_book.rb` Interactor:

```ruby
  def call
    @book = BookRepository.new.create({title: title, author: author})
  end
```

Instead of calling `Book.new`,
we create a new `BookRepository` and send `create` to it, with our attributes.

This still returns a `Book`, but it also persists this record to the database.

If you run the tests now you'll see all the tests pass.

# Dependency Injection
Let's refactor our implementation though,
to leverage Dependency Injection.

This will make our test suite more robust.
[TODO: add more benefits]

Here's how we leverage Dependency Injection in our Interactor:
```ruby
require 'hanami/interactor'

class AddBook
  include Hanami::Interactor

  expose :book

  def initialize(repository: BookRepository.new)
    @repository = repository
  end

  def call(title:, author:)
    @book = @repository.create({title: title, author: author})
  end
end
```

We don't _need_ to edit our spec, but we should.

Right now, our spec tests the behavior of the repository,
by checking to make sure `id` is populated
(`result.book.id.wont_be_nil`).

This is an implementation detail.

Instead, we can change our spec to merely make sure the repository receives the `create` message,
and trust that the repository will persist it (since that is its responsibility).

Let's change our `it "persists the Book"` assertion to:

```ruby
    it "sends :create to the repository" do
      mock = Minitest::Mock.new

      mock.expect(:create, Book.new, [attributes])

      AddBook.new(repository: mock).call(attributes)
    end
```
Now our test doesn't violate the boundaries of the concern.

What we did here is **inject** our Interactor's dependency on the repository.
Note: in our non-test code, we don't need to change anything.
The default value for the `repository:` keyword argument provides a new repository object if one is not passed in.

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

Let's keep things simple by using only the plaintext template,
Since we're keeping things simple,
let's delete the `html` email template.
Plaintext will be fine.

```shell
% rm lib/bookshelf/mailers/templates/book_added_notification.html.erb
```

TODO: finish this! test for mailer, and calling it from interactor

Edit the mailer spec `spec/bookshelf/mailers/book_added_notification_spec.rb`:
```ruby
require_relative '../../spec_helper'

describe Mailers::BookAddedNotification do
  subject { Mailers::BookAddedNotification }

  before { Hanami::Mailer.deliveries.clear }

  it 'has correct `from` email address' do
    subject.from.must_equal "no-reply@example.com"
  end

  it 'has correct `to` email address' do
    subject.to.must_equal "admin@example.com"
  end

  it 'has correct `subject`' do
    subject.subject.must_equal "Book added!"
  end

  it 'delivers mail' do
    subject.deliver
    Hanami::Mailer.deliveries.length.must_equal 1
  end
end
```


Edit the mailer `lib/bookshelf/mailers/book_added_notification.rb`:

```ruby
class Mailers::BookAddedNotification
  include Hanami::Mailer

  from    'no-reply@example.com'
  to      'admin@example.com'
  subject 'Book added!'
end
```

Now all our tests should pass!


But, the Mailer isn't called from anywhere.
We need to call this Mailer from our `AddBook` Interactor.

Let's edit our `AddBook` spec, to ensure our mailer is called:

```ruby
    ...
    it "sends :deliver to the mailer" do
      mock = Minitest::Mock.new

      mock.expect(:deliver, Mailers::BookAddedNotification.new)

      AddBook.new(mailer: mock).call(attributes)
    end
    ...
```

Running your test suite will show an error: `ArgumentError: unknown keyword: mailer`.
This makes sense, since our Interactor only a singular keyword argument: `repository`.

Let's integrate our mailer now,
by adding a new `mailer` keyword argument on the initializer.


```ruby
require 'hanami/interactor'

class AddBook
  include Hanami::Interactor

  expose :book

  def initialize(repository: BookRepository.new, mailer: Mailers::BookAddedNotification.new)
    @repository = repository
    @mailer = mailer
  end

  def call(title:, author:)
    @book = @repository.create({title: title, author: author})
    @mailer.deliver
  end
end
```

Now our Interactor will deliver an email, notifying that a book has been added.


# Error handling
What if there's an error adding the book?

In fact, the DB has constraints that neither `title`, nor `author` can be NULL.

Another constraint that could be added (but doesn't exist yet),
is a uniqueness, to prevent duplicate records.

An advantage of using Dependency Inversion is that
we don't have to check each specific error the repository can raise.

Instead, we can test it by raising an arbitrary error,
and make expectations about how our Interactor will handle it.

We know the repository should raise an error with `Hanami::Model::Error` as an ancestor class.

Let's add a spec for this, by stubbing out the repository:

```ruby
    describe "respository raises error" do
      let(:repository) { BookRepository.new }

      it "passes along error from repository" do
        repository.stub(
          :create,
          ->(*args) { raise Hanami::Model::Error, "Test DB constraint violation" }
        ) do
          result = AddBook.new(repository: repository).call(attributes)
          result.errors.must_equal ["Test DB constraint violation"]
        end
      end
```

This leverages the `errors` functionality of `Hanami::Interactor`.
We could add an expectation that `result.failure?` would equal true,
but we don't need to because `Hanami::Interactor` ensures that when there's an error.

Running the test suite will error out that test, because of the stubbing raising to raise the error.

Let's fix our Interactor to rescue from that error:
```ruby
  def call(title:, author:)
    @book = @repository.create({title: title, author: author})
    @mailer.deliver
  rescue Hanami::Model::Error => e
    error! "Error adding book: #{e.message}"
  end
```

Now our tests pass.

We can go further, too.
We can add a spec to ensure the mailer doesn't receive `deliver` when there's an error.

```ruby
      it "doesn't send mailer `deliver` when repository raises an error" do
        mailer_mock = Minitest::Mock.new

        mailer_mock.expect(:deliver, Mailers::BookAddedNotification.new)

        repository.stub(:create, ->(*args) { raise Hanami::Model::Error }) do
          AddBook.new(repository: repository, mailer: mailer_mock).call(attributes)
          -> {  mailer_mock.verify }.must_raise MockExpectationError
        end
      end
```

And this test, too, passes, since the `mailer.deliver` line is never reached,
since an error is raised.

# Validations

Validations should be placed as close to user input as possible.
The reason for this is that different use-cases can have different validations
(for example, admin validation might be less strict than normal user's validations).
In a web application, this means putting them in your controller actions.

However,
there are times when you might want to put the validations at a lower-level.
This lets you share them across the use-cases and
ensures consistent behavior from different applications.

`Hanami::Interactor` has built-in support for simple validations.
If the validations fail,
then `call` is never run and the result is `failure`, rather than `success.

You implement validations by overriding a private method named `valid?`.
By default, it returns `true`.
You make it return `false` when you want the validations to fail.

Let's say we don't want to add any books with an empty title or empty author.
Our DB constraint merely checks that the value is not NULL (`nil`, in Ruby's case),
but, by default, empty strings are still allowed.

This specific functionality, prohibiting empty strings,
could be better to write as a DB constraint.
But, a reason it could be written here, is that this could be the Interactor to add a
book as a normal user, not an administrator.
And there could be another Interactor to `AddBookAsAdmin`,
which could allow empty strings (and wouldn't send an email, since they presumably
know they added it).


```ruby
  describe "bad input" do
    it "fails for empty title" do
      result = interactor.call({title: "", author: "James Baldwin"})
      result.failure?).must_equal true
      result.errors.must_equal [
    end

    it "fails for empty author" do
      result = interactor.call({title: "The Fire Next Time", author: ""})
      expect(result.failure?).must_equal true
    end

    it "fails for empty title and author" do
      result = interactor.call({title: "", author: ""})
      expect(result.failure?).must_equal true
    end
  end
```

These three tests will fail,
because we haven't overriden `valid?` yet.

Let's override that method in our interactor:
```ruby
require 'hanami/interactor'

class SignUpUser
  include Hanami::Interactor

  # ...

  private

  def valid?(**args)
    args[:title] != "" && args[:author] != ""
  end
end
```

Now our tests should all pass.!

This is fine, but we'd like to know what went wrong.

Let's add some errors, to provide useful feedback to users of the Interactor.

We can leverage `Hanami::Interactor`'s errors feature (like we used for above for DB errors) to fix this.

```ruby
  describe "bad input" do
    it "fails for empty title" do
      result = interactor.call({title: "", author: "James Baldwin"})
      result.errors.must_equal(["Title cannot be empty"])
      result.failure?.must_equal true
    end

    it "fails for empty author" do
      result = interactor.call({title: "The Fire Next Time", author: ""})
      result.failure?.must_equal true
      result.errors.must_equal(["Author cannot be empty"])
    end

    it "fails for empty title and author" do
      result = interactor.call({title: "", author: ""})
      result.failure?.must_equal true
      result.errors.must_equal(["Title cannot be empty", "Author cannot be empty"])
    end
  end
```

These three tests will fail, because our `errors` array is still empty.

Let's fix that, by changing our implementation of `valid?`
```ruby
  private

  def valid?(**args)
    error("Title cannot be empty") if args[:title] == ""
    error("Author cannot be empty") if args[:author] == ""
    true
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


