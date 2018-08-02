---
title: "Guides - Repositories: SQL Queries"
version: 1.1
---

## Select

You can select a subset of columns to be fetched from the database:

```ruby
class UserRepository < Hanami::Repository
  def all_with_name
    users.select(:id, :name)
  end
end
```

## Sort

You can sort records using `#order`:

```ruby
class UserRepository < Hanami::Repository
  def from_first_to_last
    users.order { created_at.asc }
  end

  def from_last_to_first
    users.order { created_at.desc }
  end

  def alphabetical
    users.order { name.asc }
  end

  def alphabetical_reverse
    users.order { name.desc }
  end

  def sort_via_other_relation
    users.order(books[:title].qualified.asc)
  end
end
```

## Limit

You can use `#limit` to limit the number of records fetched from the database:

```ruby
class UserRepository < Hanami::Repository
  def last_created(number)
    users.order { created_at.desc }.limit(number)
  end
end
```

## SQL Functions

You can use any SQL functions like `ILIKE`, `IN`, `NOT`, `LENGTH`, etc..
These functions are available as Ruby methods inside the `#where` block:

```ruby
class UserRepository < Hanami::Repository
  def by_name(name)
    users.where { name.ilike("%?%", name) }
  end

  def by_id_in(input)
    users.where { id.in(input) }
  end

  def by_id_in_range(range)
    users.where { id.in(range) }
  end

  def by_id_min_max(min, max)
    users.where { id > min || id < max }
  end

  def by_not_id(input)
    users.where { id.not(input) }
  end

  def by_id_not_in_range(range)
    users.where { id.not(1..100) }
  end

  def by_name_length(input)
    users.where { length(:name) > input }
  end
end
```

## Joins

You can join several relations:

```ruby
class BookRepository < Hanami::Repository
  associations do
    has_many :comments
  end

  def commented_within(date_range)
    books
      .join(comments)
      .where(comments[:created_at].qualified => date_range)
      .as(Book)
  end
end
```

<p class="convention">
For a given relation named <code>:books</code>, the used <em>foreign key</em> in <code>:comments</code> is <code>:book_id</code>. That is the singular name of the relation with <code>\_id</code> appended to it.
</p>

In case your database schema doesn't follow this convention above, you can specify an explicit _foreign key_:

```ruby
class BookRepository < Hanami::Repository
  associations do
    has_many :comments
  end

  def commented_within(date_range)
    books
      .join(comments, id: :book_fk_id)
      .where(comments[:created_at].qualified => date_range)
      .as(Book).to_a
  end
end
```

You can also use `#inner_join` method.

## Group by

```ruby
class UserRepository < Hanami::Repository
  associations do
    has_many :books
  end

  def users_group_by_id
    users.
      left_join(:books).
      group(:id)
  end
end
```
