---
title: Lotus - Guides - Getting Started
---

# Getting Started

Set up our first Lotus project and build a simple bookshelf application. We'll
touch on all the major components of the Lotus framework, all guided by tests.

## Prerequisites

Before we get started, let's get some prerequisites out of the way.
First, we're going to assume we have basic knowledge of developing web applications.

We should also be familiar with [Bundler](http://bundler.io), [Rake](http://rake.rubyforge.org), working with a terminal and building apps using the [Model, View, Controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) paradigm.

Lastly, in this guide we'll be using a [PostgreSQL](http://www.postgresql.org) database.
If we want to follow along, make sure we have a working installation of Ruby 2.2 and PostgreSQL 9.4 on our system.

## Create a new Lotus project

To create a new Lotus project, we need to install the Lotus gem from Rubygems.
Then we can use the new `lotus` executable to generate a new project:

```
% gem install lotusrb
% lotus new bookshelf --database=postgres
```

This will create a new directory `bookshelf` in our current location.
Let's see what it contains:

```
% cd bookshelf
% tree -L 1
.
├── Gemfile
├── Gemfile.lock
├── Rakefile
├── apps
├── config
├── config.ru
├── db
├── lib
└── spec
```

Here's what we need to know:

* `Gemfile` and `Gemfile.lock` are Bundler artifacts to manage Rubygems dependencies.
* `Rakefile` is a descriptor for our Rake tasks.
* `apps` contains one or more web applications compatible with Rack.
  Here we can find the first generated Lotus application called `Web`.
  It's the place where we find our controllers, views, routes and templates.
* `config` contains configuration files.
* `config.ru` is for Rack servers.
* `db` contains our database schema and migrations.
* `lib` contains our business logic and domain model, including entities and repositories.
* `spec` contains our tests.

Go ahead and install our gem dependencie with Bundler; then we can launch a development server:

```
% bundle install
% bundle exec lotus server
```

And... bask in the glory of your first Lotus application at
[http://localhost:2300](http://localhost:3000)! We should see a screen similar to this:

<p><img src="screenshot.png" alt="Lotus first screen" class="img-responsive"></p>

## Lotus Architectures

Lotus supports a few architecture to second the needs of the current project.
The default one that we're going to explore is called _Container_, because **it can host several Lotus (and Rack) applications in the same Ruby process**.

These applications live under `apps/`.
Each of them can be a component of our product, such as the user facing web interface, the admin pane, metrics, HTTP API etc..

All these parts are a _delivery mechanism_ to the business logic that lives under `lib/`.
This is the place where our models are defined, and interact each other to compose the **features** that our product provides.

Lotus' Container is heavily inspired by [Clean Architecture](https://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html).

## Exploring App By Writing Our First Test

The opening screen we see when we point our browsers at our app now, is a
built-in page used when there are no routes defined.

Lotus encourages [Behavior Driven Development](https://en.wikipedia.org/wiki/Behavior-driven_development) (BDD) as a way to write web applications.
In order to get our first custom page to display, we'll write a high-level feature test:

```ruby
# spec/web/features/visit_home_spec.rb
require 'features_helper'

describe 'Visit home' do
  it 'is successful' do
    visit '/'

    page.body.must_include('Bookshelf')
  end
end
```

Note that, although Lotus is ready for a Behavior Driven Development workflow out of the box, **it is in no way bound to any particular testing framework** -- nor does it come with special integrations or libraries.

We'll go with [Minitest](https://github.com/seattlerb/minitest) here (which is the default), but we can use [RSpec](http://rspec.info) by creating the project with `--test=rspec` option.
Lotus will then generate helpers and stub files for it.

### Following A Request

Now we have a test, we can see it fail by running our tests:

```
% rake test
Run options: --seed 44759

# Running:

F

Finished in 0.018611s, 53.7305 runs/s, 53.7305 assertions/s.

  1) Failure:
Homepage#test_0001_is successful [/Users/lotus/bookshelf/spec/web/features/visit_home_spec.rb:6]:
Expected "<!DOCTYPE html>\n<html>\n  <head>\n    <title>Not Found</title>\n  </head>\n  <body>\n    <h1>Not Found</h1>\n  </body>\n</html>\n" to include "Bookshelf".

1 runs, 1 assertions, 1 failures, 0 errors, 0 skips
```

Our test obviously failed; now let's make it pass.
Let's add step-by-step (**only this time**) all the code needed.

As first thing we add a route:

```ruby
# apps/web/config/routes.rb
get '/', to: 'home#index'
```

We've pointed our application's root URL to the `index` action of the `home` controller (see the [routing guide](/guides/routing/overview) for more information).
Now let's create our first action.

```ruby
# apps/web/controllers/home/index.rb
module Web::Controllers::Home
  class Index
    include Web::Action

    def call(params)
    end
  end
end
```

This is an empty action that doesn't implement any business logic.
Each action has a corresponding view, which is a Ruby object and needs to be added in order to complete the request.

```ruby
# apps/web/views/home/index.erb
module Web::Views::Home
  class Index
    include Web::View
  end
end
```

...which, in turn, is empty and does nothing more than render its template.
This is the file we can edit to make our test pass. Make it look like this:

```erb
# apps/web/templates/home/index.html.erb
<h1>Bookshelf</h1>
```

Save your changes, run your test again and it now pass. Great!

```shell
Run options: --seed 19286

# Running:

.

Finished in 0.011854s, 84.3600 runs/s, 168.7200 assertions/s.

1 runs, 2 assertions, 0 failures, 0 errors, 0 skips
```

### Of Containers And Apps

Did you wonder about the `Web` constant you saw referenced in the controllers and views?
Where dit come from?
Lotus uses a _"Container"_ architecture by default, whereby a single project can contain multiple applications.
Such applications might include a JSON API, an admin panel, a marketing website, and so forth.

All these applications live under `apps/`, with the default application being called `web`.
Lotus' core frameworks are duplicated when the container boots, so configurations for different containers don't interfere with another.

Let's recap what we've seen so far: to get our own page on the screen, we followed the execution path of a request in Lotus through the router into a controller action, through a view, to a template file.

We can find out more about [routing](/guides/routing/overview), [actions](/guides/actions/overview) and [views](/guides/views/overview) in their respective guides.

## Generating New Actions

Let's use our new knowledge about the major Lotus components to add a new action.
The purpose of our Bookshelf application is to manage books.

We'll store books in our database and let user the manage them with our application.
A first step would be to show a listing of all the books in our system.

Let's write a new feature test for what we want to achieve:

```ruby
# spec/web/features/list_books_spec.rb
require 'features_helper'

describe 'List books' do
  it 'displays each book on the page' do
    visit '/books'

    within '#books' do
      assert page.has_css?('.book', count: 2), "Expected to find 2 books"
    end
  end
end
```

The test is simple enough, and obviously fails because the URL `/books` is not currently recognised in our application. We'll create a new controller action to remedy that.

### Lotus Generators

Lotus ships with various **generators** to save on typing some of the code involved in adding new functionality.
In our terminal, enter:

```
% lotus generate action web books#index
```

This will generate a new action _index_ in the _books_ controller of the _web_ application.
It gives us an empty action, view and template; it also adds a default route to `apps/web/config/routes.rb`:

```ruby
get '/books', to: 'book#index'
```

To make our test pass, we need to edit our newly generated template file in `apps/web/templates/books/index.html.erb`:

```html
<h1>Bookshelf</h1>
<h2>All books</h2>

<div id="books">
  <div class="book">
    <h3>Patterns of Enterprise Application Architecture</h3>
    <p>by <strong>Martin Fowler</strong></p>
  </div>

  <div class="book">
    <h3>Test Driven Development</h3>
    <p>by <strong>Kent Beck</strong></p>
  </div>
</div>
```

Save your changes and see your tests pass!

The terminology of controllers and actions might be confusing, so let's clear this up: actions form the basis of our Lotus applications; controllers are mere modules that group several actions together.
So while the "controller" is _conceptually_ present in our project, in practice we only deal with actions.

We've used a generator to create a new endpoint in our application.
But one thing you may have noticed is that our new template contains the same `<h1>` as our `home/index.html.erb` template.
Let's remedy that.

### Layouts

To avoid repeating ourselves in every single template, we can use a layout.
Open up the file `apps/web/templates/application.htm.erb` and edit it to look like this:

```rhtml
<!doctype HTML>
<html>
  <head>
    <title>Bookshelf</title>
  </head>
  <body>
    <h1>Bookshelf</h1>
    <%= yield %>
  </body>
</html>
```

Now you can remove the duplicate lines from the other templates.

A **layout** is a template like any other view, but it is used to wrap your regular templates.
The `yield` line is replaced with the contents of our regular template.
It's the perfect place to put our repeating headers and footers.

## Modeling Our Data With Entities

Hard-coding books in our templates is, admittedly, kind of cheating.
Let's add some dynamic data to our application.

We'll store books in our database and display them on our page.
To do so, we need a way to read and write to our database.
Enter entities and repositories:

* an **entity** is a domain object (eg. `Book`) uniquely identified by its identity.
* a **repository** mediates between entities and the persistence layer.

Entities are totally unaware of database.
This makes them **lightweight** and **easy to test**.

For this reason we need a repository to persist the data that a `Book` carries on.
Lotus uses the [Data Mapper](http://martinfowler.com/eaaCatalog/dataMapper.html) pattern.
In this way we're able to save any Ruby object in a database.
That means we can adapt Lotus to use existing Ruby projects and to provide a way to persist them.
Read more about entities and repositories in the [models guide](/guides/models/overview).

Lotus ships with a generator for models, so let's use it create a `Book` entitity and the corresponding repository:

```
% lotus generate model book
create  lib/bookshelf/entities/book.rb
create  lib/bookshelf/repositories/book_repository.rb
create  spec/bookshelf/entities/book_spec.rb
create  spec/bookshelf/repositories/book_repository_spec.rb
```

The generator gives us an entity, repository and accompanying test files.

### Working with entities

An entity is something really close to a plain Ruby object, it doesn't know nothing about our database structure.
We should focus on the behaviors that we want from it and only then, how to save it.

For now, we want it to carry title and author informations.
Let's add these attributes.

```ruby
# lib/bookshelf/entities/book.rb
class Book
  include Lotus::Entity
  attributes :title, :author
end
```

This has added some simple getters and setters to our class.
We can verify it all works as expected with a unit test:

```ruby
# spec/bookshelf/entities/book_spec.rb
require 'spec_helper'

describe Book do
  it 'can be initialised with attributes' do
    book = Book.new(title: 'Refactoring')
    book.title.must_equal 'Refactoring'
  end
end
```

### Using Repositories

We can use repositories to read and write entities to our database.
Of course, in order for that to work, we need to set up it.

Lotus configurations are stored in env variables.
This has proven to be a secure and standard way to handle credentials in deployment environments.

In order to achieve a parity between development and production machines, we use env variables loaded from `.env` files (via [dotenv](https://github.com/bkeepers/dotenv) gem).
Our projects has three of them: `.env` is for general settings, while `.env.development` and `.env.test` are complete files for these two envs.

For example, review `.env.development`:

```
# Define ENV variables for development environment
BOOKSHELF_DATABASE_URL="postgres://localhost/bookshelf_development"
WEB_SESSIONS_SECRET="21aec7f7371228dd0d4da6a620a1a6b22889edcf0d4fb1c11b8080cd87146eda"
```

The database configured by default, called `bookshelf_development` running on `localhost`, should work fine for now.
Lotus can create the database for us:

```
% lotus db create
```

### Migrations To Change Our Database Schema

Next, we need a table in our database to hold our book data.
We can use a **migration** to make the required changes.
Use the migration generator to create an empty migration:

```
% lotus generate migration create_books
```

This gives us a file named like `db/migrations/20150616120629_create_books.rb` that we can edit:

```ruby
Lotus::Model.migration do
  change do
    create_table :books do
      primary_key :id
      column :title,      String,   null: false
      column :author,     String,   null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
```

Lotus provides a DSL to describe changes to our database schema. You can read more
about how migrations work in the [migrations' guide](/guides/migrations/overview).

In this case, we define a new table with columns for each of our entitie's attributes.
Let's apply these changes to our database:

```
% lotus db migrate
```

Finally, we need to tell Lotus how to map entity attributes to database columns.
Go ahead and open up `lib/bookshelf.rb`; in this file you'll find most of the project-wide configuration for `Lotus::Model`, including a section on mapping.
Edit the commented-out example:

```ruby
# lib/bookshelf.rb
# ...
mapping do
  collection :books do
    entity     Book
    repository BookRepository

    attribute :id,         Integer
    attribute :title,      String
    attribute :author,     String
  end
end
```

### Playing With The Repository

With our mapping set up, we are ready to play around with our repository.
We can use Lotus' `console` command to launch IRb with our application pre-loaded, so we can use our objects:

```
% lotus console
>> BookRepository.all
=> []
>> book = Book.new(title: 'TDD', author: 'Kent Beck')
=> #<Book:0x007f9af1d4b028 @title="TDD", @author="Kent Beck">
>> BookRepository.create(book)
=> #<Book:0x007f9af1d13ec0 @title="TDD", @author="Kent Beck" @id=1>
>> BookRepository.find(1)
=> #<Book:0x007f9af1d13ec0 @title="TDD", @author="Kent Beck" @id=1>
```

Lotus repositories have methods to load one or more entities from our database; and to create and update existing records.
The repository is also the place where you would define new methods to implement custom queries.

To recap, we've seen how Lotus uses entities and repositories to model our data.
Entities represent our behavior, while repositories use mappings to translate our entities to our data store.
We can use migrations to apply changes to our database schema.

### Displaying Dynamic Data

With our new experience with modelling data, we can get to work displaying dynamic data on our book listing page.
Let's adjust the feature test we created earlier:

```
# spec/web/features/list_books_spec.rb
require 'features_helper'

describe 'List books' do
  before do
    BookRepository.clear

    BookRepository.create(Book.new(title: 'PoEEA', author: 'Martin Fowler'))
    BookRepository.create(Book.new(title: 'TDD', author: 'Kent Beck'))
  end

  it 'shows a book element for each book' do
    visit '/books'
    assert page.has_css?('.book', count: 2), "Expected to find 2 books"
  end
end
```

We actually create the required records in our test and then assert the correct number of book classes on the page.
When we run this test, we will most likely see an error from our database connection -- remember we only migrated our _development_ database, and not yet our _test_ database.
Its connction strings is defined in `.env.test` and here's how you set it up:

```
% LOTUS_ENV=test lotus db prepare
```

Now we can go change our template and remove the static HTML.
Our view needs to loop over all available records and render them.
Let's write a test to force this change in our view:

```ruby
require 'spec_helper'
require_relative '../../../../apps/web/views/books/index'

describe Web::Views::Books::Index do
  let(:exposures) { Hash[books: []] }
  let(:template)  { Lotus::View::Template.new('apps/web/templates/books/index.html.erb') }
  let(:view)      { Web::Views::Books::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #books" do
    view.books.must_equal exposures.fetch(:books)
  end

  describe 'when there are no books' do
    it 'shows a placeholder message' do
      rendered.must_include('<p class="placeholder">There are no books yet.</p>')
    end
  end

  describe 'when there are books' do
    let(:book1)     { Book.new(title: 'Refactoring', author: 'Martin Fowler') }
    let(:book2)     { Book.new(title: 'Domain Driven Design', author: 'Eric Evans') }
    let(:exposures) { Hash[books: [book1, book2]] }

    it 'lists them all' do
      rendered.scan(/class="book"/).count.must_equal 2
      rendered.must_include('Refactoring')
      rendered.must_include('Domain Driven Design')
    end

    it 'hides the placeholder message' do
      view.render.wont_include('<p class="placeholder">There are no books yet.</p>')
    end
  end
end
```

We specify that our index page will show a simple placeholder message when there are no books to display; when there are, it lists every one of them.
Note how rendering a view with some data is relatively straight-forward.
Lotus is designed around simple objects with minimal interfaces that are easy to test in isolation, yet still work great together.

Let's rewrite our template to implement these requirements:

```erb
<% if books.any? %>
  <% books.each do |book| %>
    <div class="book">
      <h2><%= book.title %></h2>
      <p><%= book.author %></p>
    </div>
  <% end %>
<% else %>
  <p class="placeholder">There are no books yet.</p>
<% end %>
```

If we run our feature test now, we'll see it fails — because our controller
action does not actually [_expose_](/guides/actions/exposures) the books to our view. We can write a test for
that change:

```ruby
require 'spec_helper'
require_relative '../../../../apps/web/controllers/books/index'

describe Web::Controllers::Books::Index do
  let(:action) { Web::Controllers::Books::Index.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end

  it 'exposes all books' do
    action.call(params)
    action.exposures[:books].must_equal []
  end
end
```

Writing tests for controller actions is basically two-fold: you either assert on the response object, which is a Rack-compatible array of status, headers and content; or on the action itself, which will contain exposures after we've called it.
Now we've specified that the action exposes `:books`, we can implement our action:

```ruby
module Web::Controllers::Books
  class Index
    include Web::Action

    expose :books

    def call(params)
      @books = BookRepository.all
    end
  end
end
```

By using the `expose` method in our action class, we can expose the contents of our `@books` instance variable to the outside world, so that Lotus can pass it to the view.
That's enough to make all our tests pass again!

## Buiding Forms To Create Records

One of the last steps that remains to us is to actually make it possible to enter new books into the system.
The plan is simple: we build a page with a form to enter details.

When the user submits the form, we build a new entity, save it, and redirect the user back to the book listing.
Here's that story expressed in a test:

```ruby
# spec/web/features/add_book_spec.rb
require 'features_helper'

describe 'Books' do
  after do
    BookRepository.clear
  end

  it 'can create a new book' do
    visit '/books/new'

    within 'form#book-form' do
      fill_in 'Title',  with: 'New book'
      fill_in 'Author', with: 'Some author'

      click_button 'Create'
    end

    current_path.must_equal('/books')
    assert page.has_content?('New book')
  end
end
```

### Laying The Foundations For A Form

By now, we should be familiar with the working of actions, views and templates.

We'll speed things up a little, so we can quickly get to the good parts.
First, create a new action for our "New Book" page:

```
% lotus generate action web books#new --url=/books/new
```

This adds a new route to our app:

```ruby
# apps/web/config/routes.rb
get '/books/new', to: 'books#new'
```

The interesting bit will be our new template, because we'll be using Lotus' form builder to construct an HTML form around our `Book` entity.

### Using Form Helpers

Let's use [form helpers](/guides/helpers/forms) to build this form in `apps/web/templates/books/new.html.erb`:

```erb
<h2>Add book</h2>

<%=
  form_for :book, '/books' do
    div class: 'input' do
      label      :title
      text_field :title
    end

    div class: 'intput' do
      label      :author
      text_field :author
    end

    div class: 'controls' do
      submit 'Create Book'
    end
  end
%>
```

We've added `<label>` tags for our form fields, and wrapped each field in a
container `<div>` using Lotus' [HTML builder helper](/guides/helpers/html5).

### Submitting Our Form

To submit our form, we need yet another action.
Let's create a `Books::Create` action:

```
% lotus generate action web books#create
```

Let's change the HTTP method that our route will accept (`POST`).

```ruby
# apps/web/config/routes.rb
post '/books', to: 'books#create'
```

### Implementing Create action

Our `books#create` action needs to do two things.
Let's express them as unit tests:

```ruby
# spec/web/controllers/books/create_spec.rb
require 'spec_helper'
require_relative '../../../../apps/web/controllers/books/create'

describe Web::Controllers::Books::Create do
  let(:params) { Hash[book: { title: 'Confident Ruby', author: 'Advi Grimm' }] }

  after do
    BookRepository.clear
  end

  it 'creates a new book' do
    action.call(params)
    action.book.id.wont_be_nil
  end

  it 'redirects the user to the books listing' do
    response = action.call(params)

    response[0].must_equal 302
    response[1]['Location'].must_equal '/books'
  end
end
```

Making these tests pass is easy enough.
We've already seen how we can write entities to our database, and we can use `redirect_to` to implement our redirection:

```ruby
# apps/web/controllers/books/create.rb
module Web::Controllers::Books
  class Create
    include Web::Action

    def call(params)
      book = Book.new(params[:book])
      BookRepository.create(book)

      redirect_to '/books'
    end
  end
end
```

This minimal implementation should suffice to make our tests pass.
Congratulations!

### Securing Our Form With Validations

Hold your horses! We need some extra measures to build a truly robust form.
Imagine what would happen if the were to submit the form without entering any values?

We could fill our database with bad data or see an exception for data integrity violations.
We clearly need a way of keeping invalid data out of our system!

To express our validations in a test, we need to wonder: what _would_ happen if our validations failed?
One option would be to re-render the `books#new` form, so we can give our users another shot at completing it correctly.
Let's specify this behaviour as unit tests:

```ruby
# spec/web/apps/controllers/books/create_spec.rb
require 'spec_helper'
require_relative '../../../../apps/web/controllers/books/create'

describe Web::Controllers::Books::Create do
  after do
    BookRepository.clear
  end

  describe 'with valid params' do
    let(:params) { Hash[book: { title: '1984', author: 'George Orwell' }] }

    it 'creates a new book' do
      action.call(params)
      action.book.id.wont_be_nil
    end

    it 'redirects the user to the books listing' do
      response = action.call(params)

      response[0].must_equal 302
      response[1]['Location'].must_equal '/books'
    end
  end

  describe 'with invalid params' do
    let(:params) { Hash[book: {}] }

    it 're-renders the books#new view' do
      response = action.call(params)
      response[0].must_equal 200
    end
  end
end
```

Now our tests specify two alternative scenario's: our original happy path, and a new scenario in which validations fail.
To make our tests pass, we need to implement validations.

Although you can add validation rules to the entity, Lotus also allows you to define validation rules as close to the source of the input as possible, i.e. the action.
Lotus controller actions can use the `params` class method to define acceptable incoming parameters.

This approach both whitelists what params are used (others are discarded to prevent mass-assignment vulnerabilities from untrusted user input) _and_ adds rules to define what values are acceptable — in this case we've specified that the nested attributes for a book's title and author should be present.

With our validations in place, we can limit our entity creation and redirection to cases where the incoming params are valid:

```ruby
# apps/web/controllers/books/create.rb
module Web::Controllers::Books
  class Create
    include Web::Action

    params do
      param :book do
        param :title,  presence: true
        param :author, presence: true
      end
    end

    def call(params)
      if params.valid?
        book = Book.new(params[:book])
        BookRepository.create(book)

        redirect_to '/books'
      end
    end
  end
end
```

You may have noticed that there isn't an `else` condition to that `if` statement.
What happens when params aren't valid?

The control will pass to the corresponding view, which needs to be informed about which template to render.
In this case `apps/web/templates/books/new.html.erb` will be used to render the form again.

```ruby
# apps/web/views/books/create.rb
module Web::Views::Books
  class Create
    include Web::View
    template 'books/new'
  end
end
```

This approach will work nicely because Lotus' form builder is smart enough to introspect the `params` in this action and populate the form fields with values found in the params.
If the user fills in only one field before submitting, he is presented with his original input, saving him some frustration of typing his original input again.

Run your tests again and see they are all passing again!

### Displaying Validation Errors

Rather than just shoving the user a form under his nose when something has gone wrong, we should give him a hint of what's expected of him. Let's adapt our form to show a notice about invalid fields.

First, we expect a list of errors to be included in the page when `params` contains errors:

```ruby
# spec/web/views/books/new_spec.rb
require 'spec_helper'
require_relative '../../../../apps/web/views/books/new'

let(:params)    { Lotus::Action::Params.new({}) }
let(:exposures) { Hash[params: params] }
let(:template)  { Lotus::View::Template.new('apps/web/templates/books/index.html.erb') }
let(:view)      { Web::Views::Books::New.new(template, exposures) }
let(:rendered)  { view.render }

it 'displays list of errors when params contains errors' do
  params.valid? # trigger validations

  rendered.must_include('There was a problem with your submission')
  rendered.must_include('title is required')
end
```

In our template we can loop over `params.errors` (if there are any) and display a friendly message.
Open up `apps/web/templates/books/new.html.erb`:

```erb
<% unless params.valid? %>
  <div class="errors">
    <h3>There was a problem with your submission</h3>
    <ul>
      <% params.errors.each do |error| %>
        <li><%= error.attribute_name %> is required</li>
      <% end %>
    </ul>
  </div>
<% end %>
```

As you can see, in this case we simply hard-code the error message "is required", but you could inspect the error and customise your message per type of validation that failed.
This will be improved in the near future.

### Improving Our Use Of The Router

The last improvement we are going to make, is in the use of our router.
Open up the routes file for the "web" application:

```ruby
# apps/web/config/routes.rb
post '/books', to: 'books#create'
get '/books/new', to: 'books#new'
get '/books', to: 'books#index'
get '/', to: 'home#index'
```

Lotus provides a convenient helper method to build these REST-style routes, that we can use to simplify our router a bit:

```ruby
resources :books
get '/', to: 'home#index', as: :home
```

To get a sense of what routes are defined, now we've made this change, you can
use the special command-line task `routes` to inspect the end result:

```
% lotus routes
          GET, HEAD  /                Web::Controllers::Home::Index
    books GET, HEAD  /books           Web::Controllers::Books::Index
 new_book GET, HEAD  /books/new       Web::Controllers::Books::New
    books POST       /books           Web::Controllers::Books::Create
     book GET, HEAD  /books/:id       Web::Controllers::Books::Show
edit_book GET, HEAD  /books/:id/edit  Web::Controllers::Books::Edit
     book PATCH      /books/:id       Web::Controllers::Books::Update
     book DELETE     /books/:id       Web::Controllers::Books::Destroy
```

The output for `lotus routes` shows you the name of the defined helper method (you can suffix this name with `_path` or `_url` and call it on the `routes` helper), the allowed HTTP method, the path and finally the controller action that will be used to handle the request.

Now we've applied the `resources` helper method, we can take advantage of the named route methods.
Remember how we built our form using `form_for`?

```erb
<%=
  form_for :book, "/books" do
    # ...
  end
%>
```

It's silly to include a hard-coded path in our template, when our router already is perfectly aware of the route to point the form to.
We can use the `routes` helper method that is available in our views and actions to access route-specific helper methods:

```erb
<%=
  form_for :book, routes.books_path do
    # ...
  end
%>
```

We can make a similar change in `apps/controllers/books/create.rb`:

```ruby
redirect_to routes.books_url
```

## Wrapping Up

**Congratulations for completing your first Lotus project!**

Let's review what we've done: we've traced requests through Lotus' major frameworks to understand how they relate to each other; we've seen how we can model our domain using entities and repositories; we've seen solutions for building forms, maintaining our database schema, and validating user input.

We've come a long way, but there's still plenty more to explore.
Explore the [other guides](/guides), the [Lotus API documentation](http://www.rubydoc.info/gems/lotusrb), read the [source code](https://github.com/lotus) and follow the [blog](/blog).

**Above all, enjoy building amazing things!**
