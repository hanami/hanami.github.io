---
title: Guides - Repositories
version: 1.0
---

# Repositories

An object that mediates between entities and the persistence layer.
It offers a standardized API to query and execute commands on a database.

A repository is **storage independent**, all the queries and commands are
delegated to the current adapter.

This architecture has several advantages:

  * Applications depend on a standard API, instead of low level details
    ([Dependency Inversion](https://en.wikipedia.org/wiki/Dependency_inversion_principle) principle)

  * Applications depend on a stable API, that doesn't change if the
    storage changes

  * Developers can postpone storage decisions

  * Confines persistence logic to a low level

  * Multiple data sources can easily coexist in an application

<p class="warning">
  As of the current version, Hanami only supports SQL databases.
</p>

## Interface

When a class inherits from `Hanami::Repository`, it will receive the following interface:

  * `#create(data)` – Create a record for the given data and return an entity
  * `#update(id, data)` – Update the record corresponding to the id and return the updated entity
  * `#delete(id)` – Delete the record corresponding to the given entity
  * `#all` - Fetch all the entities from the collection
  * `#find(id)` - Fetch an entity from the collection by its ID
  * `#first` - Fetch the first entity from the collection
  * `#last`  - Fetch the last entity from the collection
  * `#clear` - Delete all the records from the collection

**A collection is a homogenous set of records.**
It corresponds to a table for a SQL database or to a MongoDB collection.

```ruby
repository = BookRepository.new

book = repository.create(title: "Hanami")
  # => #<Book:0x007f95cbd8b7c0 @attributes={:id=>1, :title=>"Hanami", :created_at=>2016-11-13 16:02:37 UTC, :updated_at=>2016-11-13 16:02:37 UTC}>

book = repository.find(book.id)
  # => #<Book:0x007f95cbd5a030 @attributes={:id=>1, :title=>"Hanami", :created_at=>2016-11-13 16:02:37 UTC, :updated_at=>2016-11-13 16:02:37 UTC}>

book = repository.update(book.id, title: "Hanami Book")
  # => #<Book:0x007f95cb243408 @attributes={:id=>1, :title=>"Hanami Book", :created_at=>2016-11-13 16:02:37 UTC, :updated_at=>2016-11-13 16:03:34 UTC}>

repository.delete(book.id)

repository.find(book.id)
  # => nil
```

## Saving more than one record

For saving bunch of records you need to define a `#create_many` command:

```ruby
class BookRepository
  def create_many(list)
    command(:create, books, result: :many).call(list)
  end
end
```

Now you can use `#create_many` as a bulk creation method:

```ruby
BookRepository.new.create_many([{ title: "Hanami" }, { title: "Ruby"}])
# => [#<Book:0x007f95cbd8b7c0 @attributes={...}>, #<Book:0x007ff4e20e6f80 @attributes={...}>]
```

## Private Queries

**All the queries are private**.
This decision forces developers to define intention revealing API, instead of leaking storage API details outside of a repository.

Look at the following code:

```ruby
BookRepository.new.where(author_id: 23).order(:published_at).limit(8)
```

This is **bad** for a variety of reasons:

  * The caller has an intimate knowledge of the internal mechanisms of the Repository.

  * The caller works on several levels of abstraction.

  * It doesn't express a clear intent, it's just a chain of methods.

  * The caller can't be easily tested in isolation.

  * If we change the storage, we are forced to change the code of the caller(s).

There is a better way:

```ruby
# lib/bookshelf/repositories/book_repository.rb
class BookRepository < Hanami::Repository
  def most_recent_by_author(author, limit: 8)
    books
      .where(author_id: author.id)
      .order(:published_at)
      .limit(limit)
  end
end
```

This is a **huge improvement**, because:

  * The caller doesn't know how the repository fetches the entities.

  * The caller works on a single level of abstraction. It doesn't even know about records, only works with entities.

  * It expresses a clear intent.

  * The caller can be easily tested in isolation. It's just a matter of stubbing this method.

  * If we change the storage, the callers aren't affected.

## Timestamps

To have a track of when a record has been created or updated is important when running a project in production.

When creating a new table, if we add the following columns, a repository will take care of keeping the values updated.

```ruby
Hanami::Model.migration do
  up do
    create_table :books do
      # ...
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end
end
```

```ruby
repository = BookRepository.new

book = repository.create(title: "Hanami")

book.created_at # => 2016-11-14 08:20:44 UTC
book.updated_at # => 2016-11-14 08:20:44 UTC

book = repository.update(book.id, title: "Hanami Book")

book.created_at # => 2016-11-14 08:20:44 UTC
book.updated_at # => 2016-11-14 08:22:40 UTC
```

<p class="convention">
  When a database table has <code>created_at</code> and <code>updated_at</code> timestamps, a repository will automatically update their values.
</p>

<p class="notice">
  Timestamps are on UTC timezone.
</p>

## Legacy Databases

By default, a repository performs auto-mapping of corresponding database table and creates an [automatic schema](/guides/1.0/models/entities#automatic-schema) for the associated entity.

When working with legacy databases we can resolve the naming mismatch between the table name, the columns, with repositories defaults and entities attributes.

Let's say we have a database table like this:

```sql
CREATE TABLE t_operator (
    operator_id integer NOT NULL,
    s_name text
);
```

We can setup our repository with the following code:

```ruby
# lib/bookshelf/repositories/operator_repository.rb
class OperatorRepository < Hanami::Repository
  self.relation = :t_operator

  mapping do
    attribute :id,   from: :operator_id
    attribute :name, from: :s_name
  end
end
```

While the entity can stay with the basic setup:

```ruby
# lib/bookshelf/entities/operator.rb
class Operator < Hanami::Entity
end
```

---

The entity now gets the mapping we defined in the repository:

```ruby
operator = Operator.new(name: "Jane")
operator.name # => "Jane"
```

The repository can use the same mapped attributes:

```ruby
operator = OperatorRepository.new.create(name: "Jane")
  # => #<Operator:0x007f8e43cbcea0 @attributes={:id=>1, :name=>"Jane"}>
```

## Count

Count is a concept not generally available to all the databases. SQL databases have it, but others don't.

You can define a method, if you're using a SQL database:

```ruby
class BookRepository < Hanami::Repository
  def count
    books.count
  end
end
```

Or you can expose specific conditions:

```ruby
class BookRepository < Hanami::Repository
  # ...

  def on_sale_count
    books.where(on_sale: true).count
  end
end
```

If you want to use raw SQL you can do:

```ruby
class BookRepository < Hanami::Repository
  # ...

  def old_books_count
    books.read("SELECT id FROM books WHERE created_at < (NOW() - 1 * interval '1 year')").count
  end
end
```
