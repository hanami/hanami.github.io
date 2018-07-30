---
title: Guides - Custom Predicates
version: 1.3
---

# Custom Predicates

We have seen that built-in predicates as an expressive tool to get our job done with common use cases.

But what if our case is not common? We can define our own custom predicates.

### Inline Custom Predicates

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

### Global Custom Predicates

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

### Internationalization (I18n)

```ruby
require 'hanami/validations'

module MyPredicates
  include Hanami::Validations::Predicates

  self.messages_path = 'config/errors.yml'

  predicate(:uuid?) do |input|
    !/[0-9a-f]{8}-
    [0-9a-f]{4}-
    [0-9a-f]{4}-
    [0-9a-f]{4}-
    [0-9a-f]{12}/x.match(input).nil?
  end
end
```

```ruby
require 'hanami/validations'
require_relative 'my_predicates'

module Web::Controllers::Signup
  class Params < Hanami::Action::Params
    predicates MyPredicates

    validations do
      required(:id).filled(:uuid?)
    end
  end
end
```

```ruby
module Web::Controllers::Signup
  class Create
    include Web::Action
    params Params

    def call(params)
      # ...
    end
  end
end
```
