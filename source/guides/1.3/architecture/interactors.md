---
title: Architecture - Interactors
version: 1.3
---

# Overview
Hanami provides an **optional** tool for organizing your code.

These are *Interactors*,
also referred to *service objects*, *use-cases* or *operations*

We think they're great and help manage complexity,
but you're free to build a Hanami app without them at all.

In this guide, we'll explain how Hanami's Interactors work by adding a small feature to an existing application.

The existing application we'll work from is the `bookshelf` application
from the [Getting Started Guide](/guides/getting-started).

# A New Feature: Email Notifications
The story for our new feature is:
> As an administrator, I want to receive an email notification when a book is added

Since the application doesn't have authentication, anyone can add a new book.
We'll provide an admin email address via an environment variable.

This is just an example to show when you should use an interactor, and,
specifically, how `Hanami::Interactor` can be used.

This example could provide a basis for other features like
adding administrator approval of new books before they're posted,
or allowing users to provide an email address, then edit the book via a special link.

In practice,
you can use interactors to implement *any business logic*,
abstracted away from the web.
It's particularly useful for when you want to do several things at once,
in order to manage the complexity of the codebase.

They're used to isolate non-trivial business logic.
This follows the [Single Responsibility Principle](https://en.wikipedia.org/wiki/Single_responsibility_principle)

In a web application, they will generally be called from the controller action.
This lets you separate concerns.
Your business logic objects, interactors, won't know about the web at all.

# Callbacks? We Don't Need No Stinkin' Callbacks!
An easy way of implementing email notification would be to add a callback.

That is: after a new `Book` record is created in the database, an email is sent out.

By design, Hanami doesn't provide any such mechanism.
This is because we consider persistence callbacks an **anti-pattern**.
They violate the Single Responsibility principle.
In this case, they improperly mix persistence with email notifications.

During testing (and at some other point, most likely),
you'll want to skip that callback.
This quickly becomes confusing,
since multiple callbacks on the same event will be triggered in a specific order.
Also, you may want to skip several callbacks at some point.
They make code hard to understand, and brittle.

Instead, we recommend being **explicit over implicit**.

An interactor is an object that represents a specific *use-case*.

They let each class have a single responsibility.
An interactor's single responsibility is to combine object and method calls in order to achieve a specific outcome.

We provide `Hanami::Interactor` as a module,
so you can start with a Plain Old Ruby Object,
and include `include Hanami::Interactor` when you need some of its features.

# Concept

The central idea behind interactors is that you extract an isolated piece of functionality into a new class.

You should only write two public methods: `initialize` and `call`.

This means objects are easy to reason about,
since there's only one possible method to call after the object is created.

By encapsulating behavior into a single object, it's easier to test.
It also makes your codebase easier to understand,
rather than leaving your complexity hidden, only expressed implicitly.

# Preparing
Let's say we have our `bookshelf` application,
from the [Getting Started](/guides/getting-started)
and we want to add the 'email notification for added book' feature.

# Creating Our Interactor
Let's create a folder for our interactors, and a folder for their specs:

```shell
% mkdir lib/bookshelf/interactors
% mkdir spec/bookshelf/interactors
```
We put them in `lib/bookshelf` because they're decoupled from the web application.
Later, you may want to add books via an admin portal, an API, or even a command-line utility.

Let's call our interactor `AddBook`,
and write a new spec `spec/bookshelf/interactors/add_book_spec.rb`:

```ruby
require 'spec_helper'

describe AddBook do
  let(:interactor) { AddBook.new }
  let(:attributes) { Hash.new }

  it "succeeds" do
    expect(interactor.call(attributes)).to be_a_success
  end
end
```

(Note: Hanami has no specific RSpec integrations,
this expectation works because `Hanami::Interactor` defines a `success?` class,
which [RSpec lets us delegate to with `be_a_success`](https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers/predicate-matchers)

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
    # get it done
  end
end
```

These are the only two public methods this class should ever have:
`initialize`, to set-up the data, and
`call` to actually fulfill the use-case.

These methods, especially `call`, should call private methods that you'll write.

By default, the result is considered a success,
since we didn't say that it explicitly say it failed.

Let's run this test:

```shell
% bundle exec rake
```

All the tests should pass!

Now, let's make our `AddBook` interactor actually do something!


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
      expect(result).to be_a_success
    end

    it "creates a Book with correct title and author" do
      expect(result.book.title).to eq("The Fire Next Time")
      expect(result.book.author).to eq("James Baldwin")
    end
  end
end
```

If you run the tests with `bundle exec rake`, you'll see this error:
```ruby
NoMethodError: undefined method `book' for #<Hanami::Interactor::Result:0x007f94498c1718>
```

Let's fill out our interactor,
then explain what we did:

```ruby
require 'hanami/interactor'

class AddBook
  include Hanami::Interactor

  expose :book

  def initialize
    # set up the object
  end

  def call(book_attributes)
    @book = Book.new(book_attributes)
  end
end
```

There are two important things to note here:

The `expose :book` line exposes the `@book` instance variable as a method on the result that will be returned.

The `call` method assigns a new Book entity to the `@book` variable, which will be exposed to the result.

The tests should pass now.

We've initialized a new Book entity, but it's not persisted to the database.

# Persisting the Book
We have a new `Book` built from the title and author passed in,
but it doesn't exist in the database yet.

We need to use our `BookRepository` to persist it.

```ruby
require 'spec_helper'

describe AddBook do
  let(:interactor) { AddBook.new }
  let(:attributes) { Hash[author: "James Baldwin", title: "The Fire Next Time"] }

  describe "good input" do
    let(:result) { interactor.call(attributes) }

    it "succeeds" do
      expect(result).to be_a_success
    end

    it "creates a Book with correct title and author" do
      expect(result.book.title).to eq("The Fire Next Time")
      expect(result.book.author).to eq("James Baldwin")
    end

    it "persists the Book" do
      expect(result.book.id).to_not be_nil
    end
  end
end
```

If you run the tests,
you'll see the new expectation fails with `Expected nil to not be nil.`

This is because the book we built doesn't have an `id`,
since it only gets one if and when it is persisted.

To make this test pass, we'll need to create a _persisted_ `Book` instead.
(Another, equally valid, option would be to persist the Book we already have.)

Edit the `call` method in our `lib/bookshelf/interactors/add_book.rb` interactor:

```ruby
  def call
    @book = BookRepository.new.create(book_attributes)
  end
```

Instead of calling `Book.new`,
we create a new `BookRepository` and send `create` to it, with our attributes.

This still returns a `Book`, but it also persists this record to the database.

If you run the tests now you'll see all the tests pass.

# Dependency Injection
Let's refactor our implementation though,
to leverage [Dependency Injection](https://martinfowler.com/articles/injection.html)

We recommend you use Dependency Injection, but you don't have to.
This is an entirely optional feature of `Hanami::Interactor`.

The spec so far works,
but it relies on the behavior of the Repository
(that the `id` method is defined after persistence succeeds).
That is an implementation detail of how the Repository works.
For example, if you wanted to create a UUID *before* it's persisted,
and signify the persistence was successful in some other way than populating an `id` column,
you'd have to modify this spec.

We can change our spec and our interactor to make it more robust:
it'll be less likely to break because of changes outside of its file.

Here's how we can use Dependency Injection in our interactor:

```ruby
require 'hanami/interactor'

class AddBook
  include Hanami::Interactor

  expose :book

  def initialize(repository: BookRepository.new)
    @repository = repository
  end

  def call(book_attributes)
    @book = @repository.create(book_attributes)
  end
end
```

It's basically the same thing, with a little bit more code,
to create the `@repository` instance variable.

Right now, our spec tests the behavior of the repository,
by checking to make sure `id` is populated
(`expect(result.book.id).to_not be_nil`).

This is an implementation detail.

Instead, we can change our spec to merely make sure the repository receives the `create` message,
and trust that the repository will persist it (since that is its responsibility).

Let's change remove our `it "persists the Book"` expectation and
create a `describe "persistence"` block:

```ruby
require 'spec_helper'

describe AddBook do
  let(:interactor) { AddBook.new }
  let(:attributes) { Hash[author: "James Baldwin", title: "The Fire Next Time"] }

  describe "good input" do
    let(:result) { interactor.call(attributes) }

    it "succeeds" do
      expect(result).to be_a_success
    end

    it "creates a Book with correct title and author" do
      expect(result.book.title).to eq("The Fire Next Time")
      expect(result.book.author).to eq("James Baldwin")
    end
  end

  describe "persistence" do
    let(:repository) { instance_double("BookRepository") }

    it "persists the Book" do
      expect(repository).to receive(:create)
      AddBook.new(repository: repository).call(attributes)
    end
  end
end
```

Now our test doesn't violate the boundaries of the concern.

What we did here is **inject** our interactor's dependency on the repository.
Note: in our non-test code, we don't need to change anything.
The default value for the `repository:` keyword argument provides a new repository object if one is not passed in.

# Email Notification
Let's add the email notification!

You can use a different library,
but we'll use `Hanami::Mailer`.
(You could do anything here, like send an SMS, send a chat message, or call a webhook.)

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

We'll keep our templates empty,
so the emails will be blank,
with a subject line saying 'Book added!'.

Edit the mailer spec `spec/bookshelf/mailers/book_added_notification_spec.rb`:

```ruby
RSpec.describe Mailers::BookAddedNotification, type: :mailer do
  subject { Mailers::BookAddedNotification }

  before { Hanami::Mailer.deliveries.clear }

  it 'has correct `from` email address' do
    expect(subject.from).to eq("no-reply@example.com")
  end

  it 'has correct `to` email address' do
    expect(subject.to).to eq("admin@example.com")
  end

  it 'has correct `subject`' do
    expect(subject.subject).to eq("Book added!")
  end

  it 'delivers mail' do
    expect {
      subject.deliver
    }.to change { Hanami::Mailer.deliveries.length }.by(1)
  end
end
```


And edit the mailer `lib/bookshelf/mailers/book_added_notification.rb`:

```ruby
class Mailers::BookAddedNotification
  include Hanami::Mailer

  from    'no-reply@example.com'
  to      'admin@example.com'
  subject 'Book added!'
end
```

Now all our tests should pass!


But, this Mailer isn't called from anywhere.
We need to call this Mailer from our `AddBook` interactor.

Let's edit our `AddBook` spec, to ensure our mailer is called:

```ruby
  ...
  describe "sending email" do
    let(:mailer) { instance_double("Mailers::BookAddedNotification") }

    it "send :deliver to the mailer" do
      expect(mailer).to receive(:deliver)
      AddBook.new(mailer: mailer).call(attributes)
    end
  end
  ...
```

Running your test suite will show an error: `ArgumentError: unknown keyword: mailer`.
This makes sense, since our interactor has only a singular keyword argument: `repository`.

Let's integrate our mailer now,
by adding a new `mailer` keyword argument on the initializer.

We'll also call `deliver` on our new `@mailer` instance variable.

```ruby
require 'hanami/interactor'

class AddBook
  include Hanami::Interactor

  expose :book

  def initialize(repository: BookRepository.new, mailer: Mailers::BookAddedNotification.new)
    @repository = repository
    @mailer = mailer
  end

  def call(book_attributes)
    @book = @repository.create(book_attributes)
    @mailer.deliver
  end
end
```

Now our interactor will deliver an email, notifying that a book has been added.

# Integrating With Our Controller
Finally, we need to call this interactor from our action.

Edit the action file, `apps/web/controllers/books/create.rb`:

```
  def call(params)
    if params.valid?
      @book = AddBook.new.call(params[:book])

      redirect_to routes.books_path
    else
      self.status = 422
    end
  end
```

Our specs will still pass, but there's a small problem.

We're testing the book creation code **twice**.

This is generally bad practice, and we can fix it,
by illustrating another benefit of interactors.

We're going to use Dependency Injection again.
This time, in our action.

We'll add a `initialize` method,
with a keyword argument for `interactor`.

But first, let's the spec `spec/web/controllers/books/create_spec.rb`.

We're going to remove references to `BookRepository`,
and leverage a double for our `AddBook` interactor:

```
require 'spec_helper'

RSpec.describe Web::Controllers::Books::Create do
  let(:interactor) { instance_double('AddBook', call: nil) }
  let(:action) { Web::Controllers::Books::Create.new(interactor: interactor) }

  describe 'with valid params' do
    let(:params) { Hash[book: { title: '1984', author: 'George Orwell' }] }

    it 'calls interactor' do
      expect(interactor).to receive(:call)
      response = action.call(params)
    end

    it 'redirects the user to the books listing' do
      response = action.call(params)

      expect(response[0]).to eq(302)
      expect(response[1]['Location']).to eq('/books')
    end
  end

  describe 'with invalid params' do
    let(:params) { Hash[book: {}] }

    it 'calls interactor' do
      expect(interactor).to receive(:call)
      response = action.call(params)
    end

    it 're-renders the books#new view' do
      response = action.call(params)
      expect(response[0]).to eq(422)
    end

    it 'sets errors attribute accordingly' do
      response = action.call(params)

      expect(action.params.errors[:book][:title]).to eq(['is missing'])
      expect(action.params.errors[:book][:author]).to eq(['is missing'])
    end
  end
end
```

The test will cause an error,
because we haven't overridden our initialize.
Let's do that now,
and leverage our new instance variable in the `call` method:

```
  ...
  def initialize(interactor: AddBook.new)
    @interactor = interactor
  end

  def call(params)
    if params.valid?
      @book = @interactor.call(params[:book])

      redirect_to routes.books_path
    else
      self.status = 422
    end
  end
  ...
```

Now our specs pass, and they're much more robust!

Our action now has less responsibility;
it delegates its real behavior to our interactor.

The action takes input (from parameters),
and calls our interactor to actually do its work.
It's single responsibility is to deal with the web.
Our interactor now deals with our actual business logic.

This is a great relief for our action and its spec.

Our action is largely liberated from our business logic.

When we modify our interactor,
we do **not** have to modify our action, or its spec.

(Note that in a real app, you'll likely want to do more than our logic above,
like make sure the result is a success.
Else, if it's a failure, you'll want to pass along errors from the interactor.)

# Interactor parts
## Interface
The interface is rather simple, as shown above.
There's also one more method you can (optionally) implement.
It's a private method named `valid?`.

By default `valid?` returns true.
If you define `valid?` and it ever returns `false`,
then `call` will never be executed.

Instead, the result will be returned immediately.
This also causes the result to be a failure (instead of a success.)

You can read about it in the
[API documentation](http://www.rubydoc.info/gems/hanami-utils/Hanami/Interactor/Interface)

## Result
The result of `Hanami::Interactor#call` is a `Hanami::Interactor::Result` object.

It will have accessor methods defined for whatever instance variables you `expose`.

It also has the ability to keep track of errors.

In your interactor, you can call `error` with a message,
to add an error.
This automatically makes the resulting object a failure.

(There's also an `error!` method,
which does the same *and* also interrupts the flow,
stopping the interactor from executing more code).

You can access the errors on the resulting object, by calling `.errors`.

You can read more about the Result object in the
[API documentation](http://www.rubydoc.info/gems/hanami-utils/Hanami/Interactor/Result).
