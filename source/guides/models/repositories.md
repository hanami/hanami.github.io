---
title: Lotus - Guides - Repositories
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

## Interface

When a class includes `Lotus::Repository`, it will receive the following interface:

  * `.persist(entity)` – Create or update an entity
  * `.create(entity)`  – Create a record for the given entity
  * `.update(entity)`  – Update the record corresponding to the given entity
  * `.delete(entity)`  – Delete the record corresponding to the given entity
  * `.all`   - Fetch all the entities from the collection
  * `.find`  - Fetch an entity from the collection by its ID
  * `.first` - Fetch the first entity from the collection
  * `.last`  - Fetch the last entity from the collection
  * `.clear` - Delete all the records from the collection
  * `.query` - Fabricates a query object

**A collection is a homogenous set of records.**
It corresponds to a table for a SQL database or to a MongoDB collection.

## Private Queries

**All the queries are private**.
This decision forces developers to define intention revealing API, instead of leaking storage API details outside of a repository.

Look at the following code:

```ruby
BookRepository.where(author_id: 23).order(:published_at).limit(8)
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

class BookRepository
  include Lotus::Repository

  def self.most_recent_by_author(author, limit: 8)
    query do
      where(author_id: author.id).
        order(:published_at)
    end.limit(limit)
  end
end
```

This is a **huge improvement**, because:

  * The caller doesn't know how the repository fetches the entities.

  * The caller works on a single level of abstraction. It doesn't even know about records, only works with entities.

  * It expresses a clear intent.

  * The caller can be easily tested in isolation. It's just a matter of stubbing this method.

  * If we change the storage, the callers aren't affected.

## Extended Example

Here is an extended example of a repository that uses the SQL adapter.

```ruby
# lib/bookshelf/repositories/book_repository.rb
class BookRepository
  include Lotus::Repository

  def self.most_recent_by_author(author, limit: 8)
    query do
      where(author_id: author.id).
        desc(:id).
        limit(limit)
    end
  end

  def self.most_recent_published_by_author(author, limit = 8)
    most_recent_by_author(author, limit).published
  end

  def self.published
    query do
      where(published: true)
    end
  end

  def self.drafts
    exclude published
  end

  def self.rank
    published.desc(:comments_count)
  end

  def self.best_article_ever
    rank.limit(1)
  end

  def self.comments_average
    query.average(:comments_count)
  end
end
```

## Reuse Code

You can also extract the common logic from your repository into a module to reuse it in other repositories.
Here is a pagination example:

```ruby
# lib/bookshelf/repositories/pagination.rb
module Bookshelf
  module Repositories
    module Pagination
      def self.paginate(limit: 10, offset: 0)
        query do
          limit(limit).offset(offset)
        end
      end
    end
  end
end
```

```ruby
# lib/bookshelf/repositories/book_repository.rb
class BookRepository
  include Lotus::Repository
  include Bookshelf::Repositories::Pagination

  def self.published
    query do
      where(published: true)
    end.paginate
  end
end
```
