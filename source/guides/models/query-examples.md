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
