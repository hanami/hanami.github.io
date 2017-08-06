---
title: Guides - Entities
version: 1.0
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

An entity tries as much as it can to coerce values according to the internal schema.

---

It enforces **data integrity** via exceptions:

```ruby
Book.new(created_at: "foo") # => ArgumentError
```

If we use this feature, in combination with [database constraints](/guides/1.0/migrations/create-table#constraints) and validations, we can guarantee a **strong** level of **data integrity** for our projects.

### Custom Schema

We can take data integrity a step further: we can **optionally** define our own entity internal schema.

<p class="notice">
  Custom schema is <strong>optional</strong> for SQL databases, while it's mandatory for entities without a database table, or while using with a non-SQL database.
</p>

```ruby
# lib/bookshelf/entities/user.rb
class User < Hanami::Entity
  EMAIL_FORMAT = /\@/

  attributes do
    attribute :id,         Types::Int
    attribute :name,       Types::String
    attribute :email,      Types::String.constrained(format: EMAIL_FORMAT)
    attribute :age,        Types::Int.constrained(gt: 18)
    attribute :codes,      Types::Collection(Types::Coercible::Int)
    attribute :comments,   Types::Collection(Comment)
    attribute :created_at, Types::Time
    attribute :updated_at, Types::Time
  end
end
```

Let's instantiate it with proper values:

```ruby
user = User.new(name: "Luca", age: 34, email: "luca@hanami.test")

user.name     # => "Luca"
user.age      # => 34
user.email    # => "luca@hanami.test"
user.codes    # => nil
user.comments # => nil
```

---

It can coerce values:

```ruby
user = User.new(codes: ["123", "456"])
user.codes # => [123, 456]
```

Other entities can be passed as concrete instance:

```ruby
user = User.new(comments: [Comment.new(text: "cool")])
user.comments
  # => [#<Comment:0x007f966be20c58 @attributes={:text=>"cool"}>]
```

Or as data:

```ruby
user = User.new(comments: [{text: "cool"}])
user.comments
  # => [#<Comment:0x007f966b689e40 @attributes={:text=>"cool"}>]
```

---

It enforces **data integrity** via exceptions:

```ruby
User.new(email: "foo")     # => TypeError: "foo" (String) has invalid type for :email
User.new(comments: [:foo]) # => TypeError: :foo must be coercible into Comment
```

---

<p class="warning">
  Custom schema <strong>takes precedence</strong> over automatic schema. If we use custom schema, we need to manually add all the new columns from the corresponding SQL database table.
</p>

---

Learn more about data types in the [dedicated article](/guides/1.0/models/data-types).
