---
title: Guides - Advanced Usage
version: head
---

# Advanced Usage

### Required and Optional keys

HTML forms can have required or optional fields. We can express this concept with two methods in our validations: `required` (which we already met in previous examples), and `optional`.

```ruby
require 'hanami/validations'

class Signup
  include Hanami::Validations

  validations do
    required(:email)    { ... }
    optional(:referral) { ... }
  end
end
```

### Type Safety

At this point, we need to explicitly tell something really important about built-in predicates. Each of them have expectations about the methods that an input is able to respond to.

Why this is so important? Because if we try to invoke a method on the input we’ll get a `NoMethodError` if the input doesn’t respond to it. Which isn’t nice, right?

Before to use a predicate, we want to ensure that the input is an instance of the expected type. Let’s introduce another new predicate for our need: `#type?`.

```ruby
required(:age) { type?(Integer) & gteq?(18) }
```

It takes the input and tries to coerce it. If it fails, the execution stops. If it succeed, the subsequent predicates can trust `#type?` and be sure that the input is an integer.

**We suggest to use `#type?` at the beginning of the validations block. This _type safety_ policy is crucial to prevent runtime errors.**

`Hanami::Validations` supports the most common Ruby types:

  * `Array` (aliased as `array?`)
  * `BigDecimal` (aliased as `decimal?`)
  * `Boolean` (aliased as `bool?`)
  * `Date` (aliased as `date?`)
  * `DateTime` (aliased as `date_time?`)
  * `Float` (aliased as `float?`)
  * `Hash` (aliased as `hash?`)
  * `Integer` (aliased as `int?`)
  * `String` (aliased as `str?`)
  * `Time` (aliased as `time?`)

For each supported type, there a convenient predicate that acts as an alias. For instance, the two lines of code below are **equivalent**.

```ruby
required(:age) { type?(Integer) }
required(:age) { int? }
```

### Macros

Rule composition with blocks is powerful, but it can become verbose.
To reduce verbosity, `Hanami::Validations` offers convenient _macros_ that are internally _expanded_ (aka interpreted) to an equivalent _block expression_

#### Filled

To use when we expect a value to be filled:

```ruby
# expands to
# required(:age) { filled? }

required(:age).filled
```

```ruby
# expands to
# required(:age) { filled? & type?(Integer) }

required(:age).filled(:int?)
```

```ruby
# expands to
# required(:age) { filled? & type?(Integer) & gt?(18) }

required(:age).filled(:int?, gt?: 18)
```

In the examples above `age` is **always required** as value.

#### Maybe

To use when a value can be nil:

```ruby
# expands to
# required(:age) { none? | int? }

required(:age).maybe(:int?)
```

In the example above `age` can be `nil`, but if we send the value, it **must** be an integer.

#### Each

To use when we want to apply the same validation rules to all the elements of an array:

```ruby
# expands to
# required(:tags) { array? { each { str? } } }

required(:tags).each(:str?)
```

In the example above `tags` **must** be an array of strings.


#### Confirmation

This is designed to check if pairs of web form fields have the same value. One wildly popular example is _password confirmation_.

```ruby
required(:password).filled.confirmation
```

It is valid if the input has `password` and `password_confirmation` keys with the same exact value.

⚠ **CONVENTION:** For a given key `password`, the _confirmation_ predicate expects another key `password_confirmation`. Easy to tell, it’s the concatenation of the original key with the `_confirmation` suffix. Their values must be equal. ⚠

### Forms

An important precondition to check before to implement a validator is about the expected input.
When we use validators for already preprocessed data it's safe to use basic validations from `Hanami::Validations` mixin.

If the data is coming directly from user input via a HTTP form, it's advisable to use `Hanami::Validations::Form` instead.
**The two mixins have the same API, but the latter is able to do low level input preprocessing specific for forms**. For instance, blank inputs are casted to `nil` in order to avoid blank strings in the database.

### Rules

Predicates and macros are tools to code validations that concern a single key like `first_name` or `email`.
If the outcome of a validation depends on two or more attributes we can use _rules_.

Here's a practical example: a job board.
We want to validate the form of the job creation with some mandatory fields: `type` (full time, part-time, contract), `title` (eg. Developer), `description`, `company` (just the name) and a `website` (which is optional).
An user must specify the location: on-site or remote. If it's on site, they must specify the `location`, otherwise they have to tick the checkbox for `remote`.

Here's the code:

```ruby
class CreateJob
  include Hanami::Validations::Form

  validations do
    required(:type).filled(:int?, included_in?: [1, 2, 3])

    optional(:location).maybe(:str?)
    optional(:remote).maybe(:bool?)

    required(:title).filled(:str?)
    required(:description).filled(:str?)
    required(:company).filled(:str?)

    optional(:website).filled(:str?, format?: URI.regexp(%w(http https)))

    rule(location_presence: [:location, :remote]) do |location, remote|
      (remote.none? | remote.false?).then(location.filled?) &
        remote.true?.then(location.none?)
    end
  end
end
```

We specify a rule with `rule` method, which takes an arbitrary name and an array of preconditions.
Only if `:location` and `:remote` are valid according to their validations described above, the `rule` block is evaluated.

The block yields the same exact keys that we put in the precondintions.
So for `[:location, :remote]` it will yield the corresponding values, bound to the `location` and `remote` variables.

We can use these variables to define the rule. We covered a few cases:

  * If `remote` is missing or false, then `location` must be filled
  * If `remote` is true, then `location` must be omitted

### Nested Input Data

While we’re building complex web forms, we may find comfortable to organise data in a hierarchy of cohesive input fields. For instance, all the fields related to a customer, may have the `customer` prefix. To reflect this arrangement on the server side, we can group keys.

```ruby
validations do
  required(:customer).schema do
    required(:email) { … }
    required(:name)  { … }
    # other validations …
  end
end
```

Groups can be **deeply nested**, without any limitation.

```ruby
validations do
  required(:customer).schema do
    # other validations …

    required(:address).schema do
      required(:street) { … }
      # other address validations …
    end
  end
end
```

### Composition

Until now, we have seen only small snippets to show specific features. That really close view prevents us to see the big picture of complex real world projects.

As the code base grows, it’s a good practice to DRY validation rules.

```ruby
class AddressValidator
  include Hanami::Validations

  validations do
    required(:street) { … }
  end
end
```

This validator can be reused by other validators.

```ruby
class CustomerValidator
  include Hanami::Validations

  validations do
    required(:email) { … }
    required(:address).schema(AddressValidator)
  end
end
```

Again, there is no limit to the nesting levels.

```ruby
class OrderValidator
  include Hanami::Validations

  validations do
    required(:number) { … }
    required(:customer).schema(CustomerValidator)
  end
end
```

In the end, `OrderValidator` is able to validate a complex data structure like this:

```ruby
{
  number: "123",
  customer: {
    email: "user@example.com",
    address: {
      city: "Rome"
    }
  }
}
```

### Whitelisting

Another fundamental role that validators plays in the architecture of our projects is input whitelisting.
For security reasons, we want to allow known keys to come in and reject everything else.

This process happens when we invoke `#validate`.
Allowed keys are the ones defined with `.required`.

**Please note that whitelisting is only available for `Hanami::Validations::Form` mixin.**

### Result

When we trigger the validation process with `#validate`, we get a result object in return. It’s able to tell if it’s successful, which rules the input data has violated and an output data bag.

```ruby
result = OrderValidator.new({}).validate
result.success? # => false
```

#### Messages

`result.messages` returns a nested set of validation error messages.

Each error carries on informations about a single rule violation.

```ruby
result.messages.fetch(:number)   # => ["is missing"]
result.messages.fetch(:customer) # => ["is missing"]
```

#### Output

`result.output` is a `Hash` which is the result of whitelisting and coercions. It’s useful to pass it do other components that may want to persist that data.

```ruby
{
  "number"  => "123",
  "unknown" => "foo"
}
```

If we receive the input above, `output` will look like this.

```ruby
result.output
  # => { :number => 123 }
```

We can observe that:

  * Keys are _symbolized_
  * Only whitelisted keys are included
  * Data is coerced

### Error Messages

To pick the right error message is crucial for user experience.
As usual `Hanami::Validations` comes to the rescue for most common cases and it leaves space to customization of behaviors.

We have seen that builtin predicates have default messages, while [inline predicates](#inline-custom-predicates) allow to specify a custom message via the `:message` option.

```ruby
class SignupValidator
  include Hanami::Validations

  predicate :email?, message: 'must be an email' do |current|
    # ...
  end

  validations do
    required(:email).filled(:str?, :email?)
    required(:age).filled(:int?, gt?: 18)
  end
end

result = SignupValidator.new(email: 'foo', age: 1).validate

result.success?               # => false
result.messages.fetch(:email) # => ['must be an email']
result.messages.fetch(:age)   # => ['must be greater than 18']
```

#### Configurable Error Messages

Inline error messages are ideal for quick and dirty development, but we suggest to use an external YAML file to configure these messages:

```yaml
# config/messages.yml
en:
  errors:
    email?: "must be an email"
```

To be used like this:

```ruby
class SignupValidator
  include Hanami::Validations
  messages_path 'config/messages.yml'

  predicate :email? do |current|
    # ...
  end

  validations do
    required(:email).filled(:str?, :email?)
    required(:age).filled(:int?, gt?: 18)
  end
end

```


#### Custom Error Messages

In the example above, the failure message for age is fine: `"must be greater than 18"`, but how to tweak it? What if we need to change into something diffent? Again, we can use the YAML configuration file for our purpose.

```yaml
# config/messages.yml
en:
  errors:
    email?: "must be an email"

    rules:
      signup:
        age:
          gt?: "must be an adult"

```

Now our validator is able to look at the right error message.

```ruby
result = SignupValidator.new(email: 'foo', age: 1).validate

result.success?             # => false
result.messages.fetch(:age) # => ['must be an adult']
```

##### Custom namespace

⚠ **CONVENTION:** For a given validator named `SignupValidator`, the framework will look for `signup` translation key. ⚠

If for some reason that doesn't work for us, we can customize the namespace:

```ruby
class SignupValidator
  include Hanami::Validations

  messages_path 'config/messages.yml'
  namespace     :my_signup

  # ...
end
```

The new namespace should be used in the YAML file too.

```yaml
# config/messages.yml
en:
  # ...
    rules:
      my_signup:
        age:
          gt?: "must be an adult"

```

#### Internationalization (I18n)

If your project already depends on `i18n` gem, `Hanami::Validations` is able to look at the translations defined for that gem and to use them.


```ruby
class SignupValidator
  include Hanami::Validations

  messages :i18n

  # ...
end
```

```yaml
# config/locales/en.yml
en:
  errors:
    signup:
      # ...
```
