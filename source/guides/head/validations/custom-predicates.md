---
title: Guides - Custom Predicates
version: 1.0
---

# Custom Predicates

We have seen that built-in predicates as an expressive tool to get our job done with common use cases.

But what if our case is not common? We can define our own custom predicates.

#### Inline Custom Predicates

If we are facing a really unique validation that don't need to be reused across our code, we can opt for an inline custom predicate:

```ruby
require 'hanami/validations'

class Signup
  include Hanami::Validations

  predicate :url?, message: 'must be an URL' do |current|
    # ...
  end

  validations do
    required(:website) { url? }
  end
end
```

#### Global Custom Predicates

If our goal is to share common used custom predicates, we can include them in a module to use in all our validators:

```ruby
require 'hanami/validations'

module MyPredicates
  include Hanami::Validations::Predicates

  self.messages_path = 'config/errors.yml'

  predicate(:email?) do |current|
    current.match(/.../)
  end
end
```

We have defined a module `MyPredicates` with the purpose to share its custom predicates with all the validators that need them.

```ruby
require 'hanami/validations'
require_relative 'my_predicates'

class Signup
  include Hanami::Validations
  predicates MyPredicates

  validations do
    required(:email) { email? }
  end
end
```
