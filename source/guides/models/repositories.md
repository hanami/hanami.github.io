---
title: Guides - Repositories
---

# Repositories

An object that mediates between entities and the persistence layer.
It offers a standardized API to query and execute commands on a database.

A repository is **storage independent**, all the queries and commands are
delegated to the current adapter.

This architecture has several advantages:

  * Applications depend on a standard API, instead of low level details
    (Dependency Inversion principle)

  * Applications depend on a stable API, that doesn't change if the
    storage changes

  * Developers can postpone storage decisions

  * Confines persistence logic at a low level

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

book = book.find(book.id)
  # => #<Book:0x007f95cbd5a030 @attributes={:id=>1, :title=>"Hanami", :created_at=>2016-11-13 16:02:37 UTC, :updated_at=>2016-11-13 16:02:37 UTC}>

book = repository.update(book.id, title: "Hanami Book")
  # => #<Book:0x007f95cb243408 @attributes={:id=>1, :title=>"Hanami Book", :created_at=>2016-11-13 16:02:37 UTC, :updated_at=>2016-11-13 16:03:34 UTC}>

repository.delete(book.id)

repository.find(book.id)
  # => nil
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
