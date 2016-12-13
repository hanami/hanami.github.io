---
title: Guides - Models Overview
---

# Models

Hanami's model domain is implemented in a way that separates the behavior that we want to express ([entities](/guides/models/entities)) from that persistence layer ([repositories](/guides/models/repositories) and database).
This design helps to keep the interface of our objects really small and, by consequence, fast and reusable.

## Basic Usage

To explain the basic usage, we use a PostgreSQL database.

As first step, we generate the model:

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

```shell
% bundle exec hanami console
irb(main):001:0> book = BookRepository.new.create(title: "Hanami")
=> #<Book:0x007f95ccefb320 @attributes={:id=>1, :title=>"Hanami", :created_at=>2016-11-13 15:49:14 UTC, :updated_at=>2016-11-13 15:49:14 UTC}>
```

---

Learn more about [repositories](/guides/models/repositories), [entities](/guides/models/entities), [migrations](/guides/migrations/overview), and [database CLI commands](/guides/command-line/database).
