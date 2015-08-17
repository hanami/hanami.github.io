---
title: Lotus - Guides - Entities
---

# Entities

An _entity_ is an object that is defined by its identity.
See ["Domain Driven Design" by Eric Evans.](http://youtube.com/watch?v=7MaYeudL9yo)

An entity is the core of an application, where the part of the domain logic is implemented.
It's a small, cohesive object that expresses coherent and meaningful behaviors.

It deals with one and only one responsibility that is pertinent to the
domain of the application, without caring about details such as persistence
or validations.

This simplicity of design allows developers to focus on behaviors, or
message passing if you will, which is the quintessence of Object Oriented Programming.

All the entities live under `lib/` directory of our application.

## Interface

```ruby
# lib/bookshelf/entities/book.rb
class Book
  include Lotus::Entity
  attributes :title
end
```

When a class includes `Lotus::Entity` it receives the following interface:

  * `#id`
  * `#id=`
  * `#initialize(attributes = {})`

`Lotus::Entity` also provides the `.attributes` for defining attribute accessors for the given names.

If we expand the code above in **pure Ruby**, it would be:

```ruby
class Book
  attr_accessor :id, :title

  def initialize(attributes = {})
    @id, @title = attributes.values_at(:id, :title)
  end
end
```

**Lotus::Model** ships `Lotus::Entity` for developers's convenience.

**Lotus::Model** depends on a narrow and well-defined interface for an Entity - `#id`, `#id=`, `#initialize(attributes={})`.
If your object implements that interface then that object can be used as an Entity in the **Lotus::Model** framework.

However, we suggest to implement this interface by including `Lotus::Entity`, in case that future versions of the framework will expand it.

See [Dependency Inversion Principle](http://en.wikipedia.org/wiki/Dependency_inversion_principle) for more on interfaces.

## Inheritance

When a class extends a `Lotus::Entity` class, it will also *inherit* its mother's attributes.

```ruby
class Book
  include Lotus::Entity
  attributes :title
end

class NonFictionBook < Book
  attributes :price
end
```

That is, `NonFictionBook`'s attributes carry over `:title` attribute from `Book`,
thus is `:id, :title, :price`.
