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
