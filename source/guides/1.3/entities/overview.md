---
title: Guides - Entities Overview
version: 1.3
---

# Entities

An entity is domain object that is defined by its identity.

See ["Domain Driven Design" by Eric Evans](https://en.wikipedia.org/wiki/Domain-driven_design#Building_blocks).

An entity is at the core of an application, where the part of the domain logic is implemented.
It's a small, cohesive object that expresses coherent and meaningful behaviors.

It deals with one and only one responsibility that is pertinent to the
domain of the application, without caring about details such as persistence
or validations.

This simplicity of design allows developers to focus on behaviors, or
message passing if you will, which is the quintessence of Object Oriented Programming.

## Entity Schema

Internally, an entity holds a schema of the attributes, made of their names and types.
The role of a schema is to whitelist the data used during the initialization, and to enforce data integrity via coercions or exceptions.

We'll see concrete examples in a second.

### Automatic Schema

When using a SQL database, this is derived automatically from the table definition.

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

book.created_at       # => 2016-11-13 09:41:09 UTC
book.created_at.class # => Time
```

An entity tries as much as it cans to coerce values according to the internal schema.

---

It enforces **data integrity** via exceptions:

```ruby
Book.new(created_at: "foo") # => ArgumentError
```

If we use this feature, in combination with [database constraints](guides/1.3/migrations/create-table#constraints) and validations, we can guarantee a **strong** level of **data integrity** for our projects.

**You can set your own set of attributes via [custom schema](guides/1.3/entities/custom-schema).**
