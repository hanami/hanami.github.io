---
title: Guides - Migrations Create Tables
version: 1.2
---

# Create Tables

A table is defined via `#create_table`. This method accepts two arguments: the **name** and a **block** that expresses the design.

Safe operation can be performed via `#create_table?`. It only creates the table if it doesn't exist.
Force operation can be performed via `#create_table!`. It drops the existing table and creates a new one from scratch.
**These operations shouldn't be used in migrations**.

## Column Definition

To define a column we use `#column`, followed by the **name**, the **type** and **options**.
The name must be a unique identifier within the table.

The type can be a Ruby type (e.g. `String`), a symbol that represents a Ruby type (e.g. `:string`), or a string that represents the raw database type (e.g. `"varchar(255)"`). The only one exception in case of symbol is :Bignum. Using the symbol :Bignum as a type will use the appropriate 64-bit integer type for the database you are using.

## Type Definition

The following Ruby types are supported:

  * `String` (`varchar(255)`)
  * `Numeric` (`numeric`)
  * `Fixnum` (`integer`)
  * `Integer` (`integer`)
  * `:Bignum` (`bigint`) # Note: use this type as a symbol, since Ruby 2.4.0 removed Bignum class
  * `Float` (`double precision`)
  * `BigDecimal` (`numeric`)
  * `Date` (`date`)
  * `DateTime` (`timestamp`)
  * `Time` (`timestamp`)
  * `TrueClass` (`boolean`)
  * `FalseClass` (`boolean`)
  * `File` (`blob`)

Their translation from Ruby types to database types may vary from database to database.

### Options

It supports the following options:

  * `:default` (default value)
  * `:index` (create an index for the column)
  * `:null` (allow NULL values or not)
  * `:primary_key` (make the column primary key for the table)
  * `:unique` (add a uniqueness constraint for the column)

<p class="convention">
  Note that Hanami natively supports <strong>PostgreSQL data types</strong>.
  Learn more about them in the <a href="/guides/1.2/models/postgresql/">dedicated article</a>.
</p>

## Primary Key

We can define **primary keys** with the following syntaxes:

```ruby
column :id, Integer, null: false, primary_key: true
# or just use this shortcut
primary_key :id
```

## Foreign Keys

**Foreign keys** are defined via `#foreign_key`, where we specify the **name** of the column, the **referenced table**, and a set of **options**.
The following example creates an `author_id` column (integer) for `books` and adds a foreign key.

```ruby
create_table :books do
  # ...
  foreign_key :author_id, :authors, on_delete: :cascade, null: false
end
```

### Options

It accepts the following options:

  * `:deferrable` (make the constraint check deferrable at the end of a transaction)
  * `:key` (the column in the associated table that this column references. Unnecessary if this column references the primary key of the associated table)
  * `:null` (allow NULL values or not)
  * `:type` (the column type)
  * `:on_delete` (action to take if the referenced record is deleted: `:restrict`, `:cascade`, `:set_null`, or `:set_default`)
  * `:on_update` (action to take if the referenced record is updated: `:restrict`, `:cascade`, `:set_null`, or `:set_default`)


## Indexes

Indexes are defined via `#index`. It accepts the **name(s)** of the column(s), and a set of **options**.

```ruby
create_table :stores do
  # ...
  column :code, Integer, null: false
  column :lat, Float
  column :lng, Float

  index :code, unique: true
  index [:lat, :lng], name: :stores_coords_index
end
```

### Options

It accepts the following options:

  * `:unique` (uniqueness constraint)
  * `:name` (custom name)
  * `:type` (the type of index, supported by some databases)
  * `:where` (partial index, supported by some databases)


## Constraints

We can define constraints on columns via `#constraint`. It accepts a **name** and a **block**.

```ruby
create_table :users do
  # ...
  column :age, Integer
  constraint(:adult_constraint) { age > 18 }
end
```

Please note that the block is evaluated in the context of the database engine, **complex Ruby code doesn't work**.
Database functions are mapped to Ruby functions, but this reduces the portability of the migration.

```ruby
create_table :users do
  # ...
  column :password, String
  constraint(:password_length_constraint) { char_length(password) >= 8 }
end
```

## Checks

Checks are similar to constraints, but they accept an **anonymous block** or a **SQL raw string**.

```ruby
create_table :users do
  # ...
  column :age, Integer
  column :role, String

  check { age > 18 }
  check %(role IN('contributor', 'manager', 'owner'))
end
```
