---
title: "Guides - Associations: Belongs To"
version: 1.2
---

# Belongs To

Also known as _many-to-one_, is an association between a one of the entities (`Book`) associated to one parent entity (`Author`).

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

Let's edit `BookRepository` with the following code:

```ruby
# lib/bookshelf/repositories/book_repository.rb
class BookRepository < Hanami::Repository
  associations do
    belongs_to :author
  end

  def find_with_author(id)
    aggregate(:author).where(id: id).map_to(Book).one
  end
end
```

We have defined [explicit methods](/guides/1.2/associations/overview#explicit-interface) only for the operations that we need for our model domain.
In this way, we avoid to bloat `BookRepository` with dozen of unneeded methods.

Let's create a book:

```ruby
repository = BookRepository.new

book = repository.create(author_id: 1, title: "Hanami")
  # => #<Book:0x00007f89ac270118 @attributes={:id=>1, :author_id=>1, :created_at=>2017-10-24 08:25:41 UTC, :updated_at=>2017-10-24 08:25:41 UTC}>
```

What happens if we load the author with `BookRepository#find`?

```ruby
book = repository.find(book.id)
  # => #<Book:0x00007f89ac25ba10 @attributes={:id=>1, :author_id=>1, :created_at=>2017-10-24 08:25:41 UTC, :updated_at=>2017-10-24 08:25:41 UTC}>
book.author
  # => nil
```

Because we haven't [explicitly loaded](/guides/1.2/associations/overview#explicit-loading) the associated records, `book.author` is `nil`.
We can use the method that we have defined on before (`#find_with_author`):

```ruby
book = repository.find_with_author(book.id)
  # => #<Book:0x00007fb3f88896a0 @attributes={:id=>1, :author_id=>1, :created_at=>2017-10-24 08:25:41 UTC, :updated_at=>2017-10-24 08:25:41 UTC, :author=>#<Author:0x00007fb3f8888980 @attributes={:id=>1, :name=>"Luca", :created_at=>2017-10-24 08:25:15 UTC, :updated_at=>2017-10-24 08:25:15 UTC}>}>

book.author
  # => => #<Author:0x00007fb3f8888980 @attributes={:id=>1, :name=>"Luca", :created_at=>2017-10-24 08:25:15 UTC, :updated_at=>2017-10-24 08:25:15 UTC}>
```

This time `book.author` has the collection of associated author.

### Remove

What if we need to unassociate a book from its author?

Because we declared a _foreign key_ with the [migration](#setup), we cannot set `author_id` to `NULL` or to reference to an unexisting author.
This is a mechanism against [_orphaned records_](http://database.guide/what-is-an-orphaned-record/): a book is forced to reference a valid author.

The only way to remove a book from an author is to delete the book record.

```ruby
repository.delete(book.id)
repository.find(book.id)
  # => nil
```
