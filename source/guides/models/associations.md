---
title: Guides - Associations
---

# Associations

An association is a logical relationship between two entities.

<p class="warning">
  As of the current version, Hanami supports associations as an experimental feature only for the SQL adapter.
</p>

## Design

Because the association is made of data linked together in a database, we define associations in repositories.

### Explicit Interface

When we declare an association, that repository **does NOT** get any extra method to its public interface.
This because Hanami wants to prevent to bloat repositories with several methods that are often unused.

<p class="notice">
  When we define an association, the repository doesn't get any extra public method.
</p>

If we need to create an author, contextually with a few books, we need to explicitely define a method to perform that operation.

### Explicit Loading

The same principle applies to read operations: if we want to eager load an author with the associated books, we need an explicit method to do so.

If we don't explicitly load that books, then the resulting data will be `nil`.

### No Proxy Loader

Please remember that operations on associations are made via explicit repository methods.
Hanami **does NOT** support by design, the following use cases:

  * `author.books` (to try to load books from the database)
  * `author.books.where(on_sale: true)` (to try to load _on sale_ books from the database)
  * `author.books << book` (to try to associate a book to the author)
  * `author.books.clear` (to try to unassociate the books from the author)

Please remember that `author.books` is just an array, its mutation **won't be reflected in the database**.

## Types Of Associations

### Has Many

Also known as _one-to-many_, is an association between a single entity (`Author`) and a collection of many other linked entities (`Book`).

```shell
% bundle exec hanami generate migration create_authors
      create  db/migrations/20161115083440_create_authors.rb
```

```ruby
# db/migrations/20161115083440_create_authors.rb
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

```shell
% bundle exec hanami generate migration create_books
      create  db/migrations/20161115083644_create_books.rb
```

```ruby
# db/migrations/20161115083644_create_books.rb
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

```shell
% bundle exec hanami db prepare
```

```shell
% bundle exec hanami generate model author
      create  lib/bookshelf/entities/author.rb
      create  lib/bookshelf/repositories/author_repository.rb
      create  spec/bookshelf/entities/author_spec.rb
      create  spec/bookshelf/repositories/author_repository_spec.rb

% bundle exec hanami generate model book
      create  lib/bookshelf/entities/book.rb
      create  lib/bookshelf/repositories/book_repository.rb
      create  spec/bookshelf/entities/book_spec.rb
      create  spec/bookshelf/repositories/book_repository_spec.rb
```

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

We have defined [explicit methods](#explicit-interface) only for the operations that we need for our model domain.
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

Because we haven't [explicitely loaded](#explicit-loading) the associated records, `author.books` is `nil`.
We can use the method that we have defined on before (`#find_with_books`):

```ruby
author = repository.find_with_books(author.id)
  # => #<Author:0x007f811bbeb6f0 @attributes={:id=>1, :name=>"Alexandre Dumas", :created_at=>2016-11-15 09:19:38 UTC, :updated_at=>2016-11-15 09:19:38 UTC, :books=>[#<Book:0x007f811bbea430 @attributes={:id=>1, :author_id=>1, :title=>"The Count of Montecristo", :created_at=>2016-11-15 09:19:38 UTC, :updated_at=>2016-11-15 09:19:38 UTC}>]}>

author.books
  # => [#<Book:0x007f811bbea430 @attributes={:id=>1, :author_id=>1, :title=>"The Count of Montecristo", :created_at=>2016-11-15 09:19:38 UTC, :updated_at=>2016-11-15 09:19:38 UTC}>]
```

This time `author.books` has the collection of associated books.

---

What if we need to add or remove books from an author?
We need to define new methods to do so.

```ruby
# lib/bookshelf/repositories/author_repository.rb
class AuthorRepository < Hanami::Repository
  # ...

  def add_book(author, data)
    assoc(:books, author).add(data)
  end
end
```

Let's add a book:

```ruby
book = repository.add_book(author, title: "The Three Musketeers")
```

And remove it:

```ruby
BookRepository.new.delete(book.id)
```
