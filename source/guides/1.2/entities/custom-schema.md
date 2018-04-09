---
title: "Guides - Entities: Custom Schema"
version: 1.2
---

# Custom Schema

We can take data integrity a step further: we can **optionally** define our own entity internal schema.

<p class="notice">
  Custom schema is <strong>optional</strong> for SQL databases, while it's mandatory for entities without a database table, or while using with a non-SQL database.
</p>

<p class="warning">
  Custom schema <strong>takes precedence</strong> over automatic schema. If we use custom schema, we need to manually add all the new columns from the corresponding SQL database table.
</p>

## Default mode

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
user = User.new(name: "Luca", age: 35, email: "luca@hanami.test")

user.name     # => "Luca"
user.age      # => 35
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

## Strict mode

```ruby
# lib/bookshelf/entities/user.rb
class User < Hanami::Entity
  EMAIL_FORMAT = /\@/

  attributes :strict do
    attribute :id,    Types::Strict::Int
    attribute :name,  Types::Strict::String
    attribute :email, Types::Strict::String.constrained(format: EMAIL_FORMAT)
    attribute :age,   Types::Strict::Int.constrained(gt: 18)
  end
end
```

Let's instantiate it with proper values:

```ruby
user = User.new(id: 1, name: "Luca", age: 35, email: "luca@hanami.test")

user.id    # => 1
user.name  # => "Luca"
user.age   # => 35
user.email # => "luca@hanami.test"
```

---

It cannot be instantiated with missing keys

```ruby
User.new
  # => ArgumentError: :id is missing in Hash input
```

```ruby
User.new(id: 1, name: "Luca", age: 35)
  # => ArgumentError: :email is missing in Hash input
```

Or with `nil`:

```ruby
User.new(id: 1, name: nil, age: 35, email: "luca@hanami.test")
  # => TypeError: nil (NilClass) has invalid type for :name violates constraints (type?(String, nil) failed)
```

---

It accepts strict values and it doesn't attempt to coerce:

```ruby
User.new(id: "1", name: "Luca", age: 35, email: "luca@hanami.test")
  # => TypeError: "1" (String) has invalid type for :id violates constraints (type?(Integer, "1") failed)
```

---

It enforces **data integrity** via exceptions:

```ruby
User.new(id: 1, name: "Luca", age: 1, email: "luca@hanami.test")
  # => TypeError: 1 (Integer) has invalid type for :age violates constraints (gt?(18, 1) failed)

User.new(id: 1, name: "Luca", age: 35, email: "foo")
  # => TypeError: "foo" (String) has invalid type for :email violates constraints (format?(/\@/, "foo") failed)
```

---

**Learn more about data types in the [dedicated article](/guides/1.2/entities/data-types).**
