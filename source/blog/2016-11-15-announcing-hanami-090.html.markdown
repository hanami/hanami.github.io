---
title: Announcing Hanami v0.9.0
date: 2016-11-15 09:42 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  New hanami-model engine based on ROM.
  Database automapping, data integrity for entities, experimental associations, native PostgreSQL types.
---

We rewrote `hanami-model` from scratch with an engine based on <a href="http://rom-rb.org">ROM</a>.

The result is impressive: it's faster and more robust.

## Features

### Database Automapping

But there is more, all the **mapping boilerplate is gone**, now using entities and repositories is much **easier**.

```shell
% bundle exec hanami generate model book
      create  lib/bookshelf/entities/book.rb
      create  lib/bookshelf/repositories/book_repository.rb
      create  spec/bookshelf/entities/book_spec.rb
      create  spec/bookshelf/repositories/book_repository_spec.rb
```

This is the generated entity:

```ruby
class Book < Hanami::Entity
end
```

While this is the generated repository:

```ruby
class BookRepository < Hanami::Repository
end
```

Then we generate the migration:

```shell
% bundle exec hanami generate migration create_books
      create  db/migrations/20161113154510_create_books.rb
```

Let's edit the migration with the following code:

```ruby
Hanami::Model.migration do
  change do
    create_table :books do
      primary_key :id
      column :title,      String
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end
end
```

Now we need to prepare the database to use it:

```shell
% bundle exec hanami db prepare
```

We're ready to use our repository:

```ruby
% bundle exec hanami console
irb(main):001:0> book = BookRepository.new.create(title: "Hanami")
=> #<Book:0x007f95ccefb320 @attributes={:id=>1, :title=>"Hanami", :created_at=>2016-11-13 15:49:14 UTC, :updated_at=>2016-11-13 15:49:14 UTC}>
```

Learn more about new [repositories](/guides/models/repositories), [entities](/guides/models/entities) usage.

### Entities Data Integrity

When using a SQL database, an entity setups an **internal schema**, which is derived **automatically** from the table definition.

Imagine to have the `books` table defined as:

```sql
CREATE TABLE books (
    id integer NOT NULL,
    title text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
```

This is the corresponding entity `Book`.

```ruby
# lib/bookshelf/entities/book.rb
class Book < Hanami::Entity
end
```

---

Let's instantiate it with proper values:

```ruby
book = Book.new(title: "Hanami")

book.title      # => "Hanami"
book.created_at # => nil
```

The `created_at` attribute is `nil` because it wasn't present when we have instantiated `book`.

---

It ignores unknown attributes:

```ruby
book = Book.new(unknown: "value")

book.unknown # => NoMethodError
book.foo     # => NoMethodError
```

It raises a `NoMethodError` both for `unknown` and `foo`, because they aren't part of the internal schema.

---

It can coerce values:

```ruby
book = Book.new(created_at: "Sun, 13 Nov 2016 09:41:09 GMT")

book.created_at # => 2016-11-13 09:41:09 UTC
book.class      # => Time
```

An entity tries as much as it cans to coerce values according to the internal schema.

---

It enforces **data integrity** via exceptions:

```ruby
Book.new(created_at: "foo") # => ArgumentError
```

If we use this feature, in combination with [database constraints](/guides/migrations/create-table#constraints) and validations, we can ensure a **strong** degree of **data integrity** for our projects.

Learn more about Entities [custom schema](/guides/models/entities#custom-schema).

### Associations (experimental)

Hanami finally ships with associations.
We postponed this feature for long time mainly because we didn't want to replicate ActiveRecord API.
That is a complex beast that took years to get stable.
Its proxy loader design (`post.comments` to load comments) doesn't fit Hanami vision of explicitness.

To design an API that is both explicit and reduces the boilerplate is a hard challenge.
But today we can share with you a preview of this experimental feature.

```ruby
class AuthorRepository < Hanami::Repository
  associations do
    has_many :books
  end

  def create_with_books(data)
    assoc(:books).create(data)
  end

  def find_with_books(id)
    aggregate(:books).where(authors__id: id).as(Author).one
  end
end
```

We can create with a single SQL command the parent and the children:

```ruby
repository = AuthorRepository.new

author = repository.create_with_books(name: "Alexander Dumas", books: [{title: "The Count of Monte Cristo" }])
  # => #<Author:0x007f8a08130968 @attributes={:id=>1, :name=>"Alexander Dumas", :created_at=>2016-11-14 20:52:24 UTC, :updated_at=>2016-11-14 20:52:24 UTC, :books=>[#<Book:0x007f8a0812b260 @attributes={:id=>1, :author_id=>1, :title=>"The Count of Monte Cristo", :created_at=>2016-11-14 20:52:24 UTC, :updated_at=>2016-11-14 20:52:24 UTC}>]}>
```

The default find, doesn't preload the associated records:

```ruby
found = repository.find(author.id)
  # => #<Author:0x007f8a07971ce0 @attributes={:id=>1, :name=>"Alexander Dumas", :created_at=>2016-11-14 20:52:24 UTC, :updated_at=>2016-11-14 20:52:24 UTC}>

found.books
  # => nil
```

It requires an explicit preload operation:

```ruby
found = repository.find_with_books(author.id)
  # => #<Author:0x007f8a040a6cf8 @attributes={:id=>1, :name=>"Alexander Dumas", :created_at=>2016-11-14 20:52:24 UTC, :updated_at=>2016-11-14 20:52:24 UTC, :books=>[#<Book:0x007f8a040a5970 @attributes={:id=>1, :author_id=>1, :title=>"The Count of Monte Cristo", :created_at=>2016-11-14 20:52:24 UTC, :updated_at=>2016-11-14 20:52:24 UTC}>]}>

found.books
  # => [#<Book:0x007f8a040a5970 @attributes={:id=>1, :author_id=>1, :title=>"The Count of Monte Cristo", :created_at=>2016-11-14 20:52:24 UTC, :updated_at=>2016-11-14 20:52:24 UTC}>]
```

Learn more about [associations](/guides/models/associations).

### PostgreSQL Types

`hanami-model` now supports natively most common PostgreSQL data types such as: `UUID`, `Array`, `JSON(B)`

```ruby
Hanami::Model.migration do
  up do
    execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'

    create_table :project_files do
      column :id, 'uuid', null: false, default: Hanami::Model::Sql.function(:uuid_generate_v4)
      column :name, String
    end
  end

  down do
    drop_table :project_files
    execute 'DROP EXTENSION IF EXISTS "uuid-ossp"'
  end
end
```

```ruby
ProjectFileRepository.new.create(name: "source.rb")
  # => #<ProjectFile:0x007ff29c4b9740 @attributes={:id=>"239f8e0f-d764-4a76-aaa7-7b59b5301c72", :name=>"source.rb"}>
```

Learn more about [PostgreSQL data types](/guides/models/postgresql)

### Misc

- Hanami is only compatible with Ruby (MRI) 2.3+

- There are several breaking changes, please check the upgrade notes

## Upgrade Notes

Please have a look at the [upgrade notes for v0.9.0](/guides/upgrade-notes/v090).

## Acknowledgements

A special thanks goes to the ROM team for their support during the hard work of integration between the two frameworks.
Thank you Piotr Solnica, Nikita Shilnikov, Andy Holland, and Tim Riley for your help.

## Contributors

We're grateful for each person who contributed to this release.
These lovely people are:

  * Alfonso Uceda
  * Anton Davydov
  * Bruz Marzolf
  * Grachev Mikhail
  * Ivan Lasorsa
  * Jakub Pavlík
  * James Hamilton
  * Kyle Chong
  * Lucas Allan
  * Marion Duprey
  * Maxim Dzhuliy
  * Pascal Betz
  * Russell Cloak
  * Sean Collins
  * Tomas Craig
  * Trung Lê

Thank you all!
