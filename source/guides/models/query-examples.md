---
title: Guides - Query Examples
---

## Order

For add `order` to your relation just call `#order` method with block:

```ruby
repo = UserRepository.new

repo.users.order { created_at.desc }
repo.users.order { created_at.asc }

# you can set any field for order
repo.users.order { name.asc }
repo.users.order { last_name.asc }

# you can use other relation for ordering
repo.users.order(repo.books[:title].qualified.asc)
```

## SQL Functions

You can use any SQL functions like `LIKE`, `ILIKE`, etc. For this call this functions in `where` block:

```ruby
repo = UserRepository.new

repo.users.where { name.ilike('%anton%') }
repo.users.where { name.like('%anton%') }

# you can call IN functions too
repo.users.where { id.in(1) }
repo.users.where { id.in(1..100) }
repo.users.where { id > 1 || id < 100 }

# you can call NOT functions too
repo.users.where { id.not(1) }
repo.users.where { id.not(1..100) }
```

```ruby
name = repo.user[:name].qualified
repo.where { length(name) > 10) }
```

```ruby
repo.users.where { id.in(1..100) }.limit(100)
```

```ruby
repo.users.where(id: 1) == repo.users.by_pk(1)
```

## Joins
https://stackoverflow.com/questions/43080678/join-query-in-hanami-model/43156257#43156257

```ruby

repo.users.join(:posts)
repo.users.join(:posts, id: :user_id)
repo.users.join(repo.posts)
```

also you can use `#inner_join` method

## Group by

Examples with groyp you can find here:
https://github.com/rom-rb/rom-sql/blob/master/spec/unit/relation/group_spec.rb

Also you can't use `#select` in hanami model. YOu need to use `#project` instead
