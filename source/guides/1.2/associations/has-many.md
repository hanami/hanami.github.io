---
title: "Guides - Associations: Has Many"
version: 1.2
---

# Has Many

Also known as _one-to-many_, is an association between a single entity (`Author`) and a collection of many other linked entities (`Book`).

## Setup

```shell
% bundle exec hanami generate model author
      create  lib/bookshelf/entities/author.rb
      create  lib/bookshelf/repositories/author_repository.rb
      create  db/migrations/20171024081558_create_authors.rb
      create  spec/bookshelf/entities/author_spec.rb
      create  spec/bookshelf/repositories/author_repository_spec.rb

% bundle exec hanami generate model book
      create  lib/bookshelf/entities/book.rb
      create  lib/bookshelf/repositories/book_repository.rb
      create  db/migrations/20171024081617_create_books.rb
      create  spec/bookshelf/entities/book_spec.rb
      create  spec/bookshelf/repositories/book_repository_spec.rb
```

Edit the migrations:

```ruby
# db/migrations/20171024081558_create_authors.rb
Hanami::Model.migration do
  change do
    create_table :authors do
      primary_key :id

      column :name,       String,   null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
```

```ruby
# db/migrations/20171024081617_create_books.rb
Hanami::Model.migration do
  change do
    create_table :books do
      primary_key :id

      foreign_key :author_id, :authors, on_delete: :cascade, null: false

      column :title,      String,   null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
```

Now we can prepare the database:

```shell
% bundle exec hanami db prepare
```

## Usage

### Basic usage

Let's edit `AuthorRepository` with the following code:

```ruby
# lib/bookshelf/repositories/author_repository.rb
class AuthorRepository < Hanami::Repository
  associations do
    has_many :books
  end

  def create_with_books(data)
    assoc(:books).create(data)
  end

  def find_with_books(id)
    aggregate(:books).where(id: id).as(Author).one
  end
end
```

We have defined [explicit methods](/guides/1.2/associations/overview#explicit-interface) only for the operations that we need for our model domain.
In this way, we avoid to bloat `AuthorRepository` with dozen of unneeded methods.

Let's create an author with a collection of books with a **single database operation**:

```ruby
repository = AuthorRepository.new

author = repository.create_with_books(name: "Alexandre Dumas", books: [{title: "The Count of Montecristo"}])
  # => #<Author:0x007f811c415420 @attributes={:id=>1, :name=>"Alexandre Dumas", :created_at=>2016-11-15 09:19:38 UTC, :updated_at=>2016-11-15 09:19:38 UTC, :books=>[#<Book:0x007f811c40fe08 @attributes={:id=>1, :author_id=>1, :title=>"The Count of Montecristo", :created_at=>2016-11-15 09:19:38 UTC, :updated_at=>2016-11-15 09:19:38 UTC}>]}>

author.id
  # => 1
author.name
  # => "Alexandre Dumas"
author.books
  # => [#<Book:0x007f811c40fe08 @attributes={:id=>1, :author_id=>1, :title=>"The Count of Montecristo", :created_at=>2016-11-15 09:19:38 UTC, :updated_at=>2016-11-15 09:19:38 UTC}>]
```

What happens if we load the author with `AuthorRepository#find`?

```ruby
author = repository.find(author.id)
  # => #<Author:0x007f811b6237e0 @attributes={:id=>1, :name=>"Alexandre Dumas", :created_at=>2016-11-15 09:19:38 UTC, :updated_at=>2016-11-15 09:19:38 UTC}>
author.books
  # => nil
```

Because we haven't [explicitly loaded](/guides/1.2/associations/overview#explicit-loading) the associated records, `author.books` is `nil`.
We can use the method that we have defined on before (`#find_with_books`):

```ruby
author = repository.find_with_books(author.id)
  # => #<Author:0x007f811bbeb6f0 @attributes={:id=>1, :name=>"Alexandre Dumas", :created_at=>2016-11-15 09:19:38 UTC, :updated_at=>2016-11-15 09:19:38 UTC, :books=>[#<Book:0x007f811bbea430 @attributes={:id=>1, :author_id=>1, :title=>"The Count of Montecristo", :created_at=>2016-11-15 09:19:38 UTC, :updated_at=>2016-11-15 09:19:38 UTC}>]}>

author.books
  # => [#<Book:0x007f811bbea430 @attributes={:id=>1, :author_id=>1, :title=>"The Count of Montecristo", :created_at=>2016-11-15 09:19:38 UTC, :updated_at=>2016-11-15 09:19:38 UTC}>]
```

This time `author.books` has the collection of associated books.

### Add and remove

What if we need to add or remove books from an author?
We need to define new methods to do so.

```ruby
# lib/bookshelf/repositories/author_repository.rb
class AuthorRepository < Hanami::Repository
  # ...

  def add_book(author, data)
    assoc(:books, author).add(data)
  end

  def remove_book(author, id)
    assoc(:books, author).remove(id)
  end
end
```

Let's add a book:

```ruby
book = repository.add_book(author, title: "The Three Musketeers")
```

And remove it:

```ruby
repository.remove_book(author, book.id)
```

### Querying

An association can be [queried](/guides/1.2/repositories/sql-queries):

```ruby
# lib/bookshelf/repositories/author_repository.rb
class AuthorRepository < Hanami::Repository
  # ...

  def books_count(author)
    assoc(:books, author).count
  end

  def on_sales_books_count(author)
    assoc(:books, author).where(on_sale: true).count
  end

  def find_book(author, id)
    book_for(author, id).one
  end

  def book_exists?(author, id)
    book_for(author, id).exists?
  end

  private

  def book_for(author, id)
    assoc(:books, author).where(id: id)
  end
end
```

You can also run operations on top of these scopes:

```ruby
# lib/bookshelf/repositories/author_repository.rb
class AuthorRepository < Hanami::Repository
  # ...

  def delete_on_sales_books(author)
    assoc(:books, author).where(on_sale: true).delete
  end
end
```
