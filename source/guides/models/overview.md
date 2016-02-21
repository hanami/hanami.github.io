---
title: Hanami | Guides - Models Overview
---

# Models

Hanami's model domain is implemented in a way that separates the behavior that we want to express (entities) from that persistence layer (repositories and database).
This design helps to keep the interface of our objects really small and, by consequence, fast and reusable.

## Soft Dependency

If we look at the `Gemfile` of our generated application, `hanami-model` gem is a separated entry.
That means our applications don't depend on this framework.

**We are free to bring our own ORM and/or persistency library.**

## Adapters

`Hanami::Model` is designed to expose high level operations to perform against a database.
This allows to swap the storage, without affecting the code of our application.

For this purpose the framework has a concept of _adapter_.
It's layer of code that targets a specific data store and exposes a common set of operations.

While we'll **NEVER** work with them directly, it's important to know that Hanami ships with three types of adapters:

  * File System (default)
  * Memory
  * SQL

File System is the default adapter, because it's a schema-less storage for quick prototyping.
It helps us to focus on behavior without worrying about database migrations before starting to code our feature.

We can use `--database` command line argument to specify the adapter that we want to use for newly created applications.

It generates some code in `lib/bookshelf.rb` that sets the current adapter (`:sql`) and shows examples for the available choices.

```ruby
# lib/bookshelf.rb
# ...
Hanami::Model.configure do
  ##
  # Database adapter
  #
  # Available choices:
  #
  #  * File System adapter
  #    adapter type: :file_system, uri: 'file:///db/bookshelf_development'
  #
  #  * Memory adapter
  #    adapter type: :memory, uri: 'memory://localhost/bookshelf_development'
  #
  #  * SQL adapter
  #    adapter type: :sql, uri: 'sqlite://db/bookshelf_development.sqlite3'
  #    adapter type: :sql, uri: 'postgres://localhost/bookshelf_development'
  #    adapter type: :sql, uri: 'mysql://localhost/bookshelf_development'
  #
  adapter type: :sql, uri: ENV['BOOKSHELF_DATABASE_URL']

  # ...
end.load!
```

## Mapping

The partitioning between our application's domain and databases is resolved by using a data mapper.
We use it to describe how each entity must be persisted.

This can be inconvenient at the beginning, when we deal with a few entities and attributes, but as our codebase grows, we are in **total control** of how our code interacts with a database.

Another strong point in favor of this choice is that **we can persist nearly any Ruby object, even if it wasn't designed to do so**.

Our application comes with a default mapper in `lib/bookshelf.rb`, we can use it to specify our persistence preferences.

```ruby
# ...

Hanami::Model.configure do
  # ...
  mapping do
    collection :books do
      entity     Book
      repository BookRepository

      attribute :id,    Integer
      attribute :title, String
    end
  end
end.load!
```

The first thing we should look at is `#collection`.
It's the unique name of a set of coherent records or documents.
For instance, if used with SQL adapter, it's the name of the database table.

It accepts a block that allows us to associate an [entity](/guides/models/entities) and a [repository](/guides/models/repositories) with it.

Then we list all the attributes from the `Book` entity that we want to persist and their Ruby type.

### Entity vs Database Mismatching

Imagine we're building a Ruby library for Twitter, and we have a `Tweet` object that we want to save in our database.


```ruby
class Tweet
  attr_accessor :id, :user_id, :text, :favorite_count, :retweet_count,
    :lat, :lng, :reply, :retweet, :quoted

  def initialize(attributes = {})
    # ...
  end
end
```

It comes with a lot of data, but we're only interested to persist a subset of it (the first line defined by `attr_accessor`).

```ruby
collection :tweets do
  entity     Tweet
  repository TweetRepository

  attribute :id,             Integer
  attribute :user_id,        Integer
  attribute :text,           String
  attribute :favorite_count, Integer
  attribute :retweet_count,  Integer
end
```

All the other attributes are just ignored by our repository.

### Legacy Databases

Until now we've worked with the assumption of working with a new database, grown alongside with production code.
If this isn't the case for us, we can use _data mapper_ do resolve this mismatch.

```sql
CREATE TABLE book_catalog (
    _id integer NOT NULL,
    s_title text
);
```

Imagine we have the above Postgres table from our legacy database and we want to map it to our `Book` entity.

```ruby
collection :book_catalog do
  entity     Book
  repository BookRepository

  identity :_id

  attribute :id,    Integer, as: :_id
  attribute :title, String,  as: :s_title
end
```

The first thing that we notice is the correspondence between `#collection` name and the database table name.

Then the argument that we pass to `#attribute` is the name of the attribute from `Book`.
If the database column name has the same attribute name we're done.
In our case we need to use `:as` option, to indicate the database column that we want to map.

Hanami collections assume the primary key for a table is the `id` column, but this example uses `_id` instead. We can
change the primary key for a collection by using the `identity` setting which takes a single column name.

### Custom Coercions

Hanami data mapper supports the most common Ruby data type such as `String`, `Integer`, or `DateTime`.
Sometimes, this simple approach is not enough to solve the database impedance mismatch on types.

Imagine we have a `Book#tags`, a collection of strings that we want to store as a [Postgres array](http://www.postgresql.org/docs/9.1/static/arrays.html).
If we use `Array` builtin type, our tags aren't properly translated into a format that is compatible with our column type.

The solution to this problem is to define a custom coercer.

```ruby
# lib/ext/pg_array.rb
require 'hanami/model/coercer'
require 'sequel'
require 'sequel/extensions/pg_array'

class PGArray < Hanami::Model::Coercer
  def self.dump(value)
    ::Sequel.pg_array(value, :varchar)
  end

  def self.load(value)
    ::Kernel.Array(value) unless value.nil?
  end
end
```

```ruby
# lib/bookshelf.rb
require_relative './ext/pg_array'
# ...

Hanami::Model.configure do
  # ...
  mapping do
    # ...
    collection :articles do
      attribute :id,   Integer
      attribute :tags, PGArray
    end
  end
end.load!
```

<p class="warning">
  A custom coercer **MUST** respond to <code>.dump(value)</code> for serialization and to <code>.load(value)</code> for deserialization.
</p>

### Use UUID as primary key instead of integer

When using Postgres, you may use [UUID Type](http://www.postgresql.org/docs/8.3/static/datatype-uuid.html) as primary keys instead if integers.
First of all, you need to enable <code>uuid-ossp</code> extension:

```ruby
# db/migrations/20160125223305_enable_uuid_extensions.rb
Hanami::Model.migration do
  change do
    run 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'
  end
end
```

Then, create table with <code>uuid</code> type and set default value:

```ruby
# db/migrations/20160126223305_create_books.rb
Hanami::Model.migration do
  create_table :books do
    primary_key :id, :uuid, default: Sequel.function(:uuid_generate_v4)
  end
end
```
