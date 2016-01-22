---
title: Hanami | Guides - Migrations
---

# Migrations

Migrations are a feature that allows to manage database schema via Ruby.
They come with some [command line facilities](/guides/command-line/database) that allow to perform database operations or to [generate](/guides/command-line/generators) migrations.

Migrations are only available if our application uses the [SQL adapter](/guides/models/overview).

## Anatomy Of A Migration

Migrations are Ruby files stored by default under `db/migrations`.
Their name is composed by a UTC timestamp and a snake case name (eg `db/migrations/20150621165604_create_books.rb`).

```ruby
Hanami::Model.migration do
  change do
    create_table :books do
      primary_key :id
      foreign_key :author_id, :authors, on_delete: :cascade, null: false

      column :code,  String,  null: false, unique: true, size: 128
      column :title, String,  null: false
      column :price, Integer, null: false, default: 100 # cents

      check { price > 0 }
    end
  end
end
```

We use a `create_table` block to define the schema of that table.

The first line is `primary_key :id`, which is a shortcut to create an autoincrement integer column.

There is a foreign key definition with cascade deletion.
The first argument is the name of the local column (`books.author_id`), while the second is the referenced table.

Then we have three lines for columns.
The first argument that we pass to `#column` is the name, then the type.
The type can be a **Ruby type** such as `String` or `Integer` or a string that represents the **native database type** (eg. `"varchar(32)"` or `"text[]"`).

As a last optional argument there is a Hash that specifies some extra details for the column. For instance NULL or uniqueness constraints, the size (for strings) or the default value.

The final line defines a database **check** to ensure that price will always be greater than zero.

## Up/Down

When we "migrate" a database we are going into an _"up"_ direction because we're adding alterations to it.
Migrations modifications can be rolled back (_"down"_ direction).

When we use `change` in our migrations, we're implicitly describing _"up"_ modifications.
Their counterpart can be inferred by `Hanami::Model` when we migrate _"down"_ our database.

Imagine we have the following code:

```ruby
Hanami::Model.migration do
  change do
    create_table :books do
      # ...
    end
  end
end
```

When we use `create_table`, Hanami::Model will use `drop_table` in case we want to rollback this migration.

In case we want to have concrete code for our _"down"_ policy, we can use `up` and `down` blocks.

```ruby
Hanami::Model.migration do
  up do
    create_table :books do
      # ...
    end
  end

  down do
    drop_table :books
  end
end
```

## References

Hanami::Model uses [Sequel](http://sequel.jeremyevans.net/) under the hood as database migration engine. If there is any aspect that isn't covered by our documentation or tests, please refer to [Sequel documentation](http://sequel.jeremyevans.net/rdoc/files/doc/schema_modification_rdoc.html).
