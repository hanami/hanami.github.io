---
title: Guides - Boolean Logic
version: 1.1
---

# Boolean Logic

When we check data, we expect only two outcomes: an input can be valid or not. No grey areas, nor fuzzy results. It’s white or black, 1 or 0, `true` or `false` and _boolean logic_ is the perfect tool to express these two states. Indeed, a Ruby _boolean expression_ can only return `true` or `false`.

To better recognise the pattern, let’s get back to the example above. This time we will map the natural language rules with programming language rules.

```
required(:name) { filled? & str? & size? (3..64) }
```

Now, I hope you’ll never format code like that, but in this case, that formatting serves well our purpose to show how Ruby’s  simplicity helps to define complex rules with no effort.

From a high level perspective, we can tell that input data for `name` is _valid_ only if **all** the requirements are satisfied. That’s because we used `&`.

#### Logic Operators

We support four logic operators:

  * `&` (aliased as `and`) for _conjunction_
  * `|` (aliased as `or`) for _disjunction_
  * `>` (aliased as `then`) for _implication_
  * `^` (aliased as `xor`) for _exclusive disjunction_

#### Context Of Execution

**Please notice that we used `&` over Ruby's `&&` keyword.**
That's because the context of execution of these validations isn't a plain lambda, but something richer.

For real world projects, we want to support common scenarios without the need of reinventing the wheel ourselves. Scenarios like _password confirmation_, _size check_ are already prepackaged with `Hanami::Validations`.


⚠ **For this reason, we don't allow any arbitrary Ruby code to be executed, but only well defined predicates.** ⚠

### Predicates

To meet our needs, `Hanami::Validations` has an extensive collection of **built-in** predicates. **A predicate is the expression of a business requirement** (e.g. _size greater than_). The chain of several predicates determines if input data is valid or not.

We already met `filled?` and `size?`, now let’s introduce the rest of them. They capture **common use cases with web forms**.

### Array

It checks if the the given value is an array, and iterates through its elements to perform checks on each of them.

```ruby
required(:codes) { array? { each { int? } } }
```

This example checks if `codes` is an array and if all the elements are integers, whereas the following example checks there are a minimum of 2 elements and all elements are strings.

```ruby
required(:codes) { array? { min_size?(2) & each { str? } } }
```

#### Emptiness

It checks if the given value is empty or not. It is designed to works with strings and collections (array and hash).

```ruby
required(:tags) { empty? }
```

#### Equality

This predicate tests if the input is equal to a given value.

```ruby
required(:magic_number) { eql?(23) }
```

Ruby types are respected: `23` (an integer) is only equal to `23`, and not to `"23"` (a string). See _Type Safety_ section.

#### Exclusion

It checks if the input is **not** included by a given collection. This collection can be an array, a set, a range or any object that responds to `#include?`.

```ruby
required(:genre) { excluded_from?(%w(pop dance)) }
```

#### Format

This is a predicate that works with a regular expression to match it against data input.

```ruby
require 'uri'
HTTP_FORMAT = URI.regexp(%w(http https))

required(:url) { format?(HTTP_FORMAT) }
```

#### Greater Than

This predicate works with numbers to check if input is **greater than** a given threshold.

```ruby
required(:age) { gt?(18) }
```

#### Greater Than Equal

This is an _open boundary_ variation of `gt?`. It checks if an input is **greater than or equal** of a given number.

```ruby
required(:age) { gteq?(19) }
```

#### Inclusion

This predicate is the opposite of `#exclude?`: it verifies if the input is **included** in the given collection.

```ruby
required(:genre) { included_in?(%w(rock folk)) }
```

#### Less Than

This is the complement of `#gt?`: it checks for **less than** numbers.

```ruby
required(:age) { lt?(7) }
```

#### Less Than Equal

Similarly to `#gteq?`, this is the _open bounded_ version of `#lt?`: an input is valid if it’s **less than or equal** to a number.

```ruby
required(:age) { lteq?(6) }
```

#### Filled

It’s a predicate that ensures data input is filled, that means **not** `nil` or blank (`""`) or empty (in case we expect a collection).

```ruby
required(:name) { filled? }      # string
required(:languages) { filled? } # collection
```

#### Minimum Size

This verifies that the size of the given input is at least of the specified value.

```ruby
required(:password) { min_size?(12) }
```

#### Maximum Size

This verifies that the size of the given input is at max of the specified value.

```ruby
required(:name) { max_size?(128) }
```

#### None

This verifies if the given input is `nil`. Blank strings (`""`) won’t pass this test and return `false`.

```ruby
required(:location) { none? }
```

#### Size

It checks if the size of input data is: a) exactly the same of a given quantity or b) it falls into a range.

```ruby
required(:two_factor_auth_code) { size?(6) }     # exact
required(:password)             { size?(8..32) } # range
```

The check works with strings and collections.

```ruby
required(:answers) { size?(2) } # only 2 answers are allowed
```

This predicate works with objects that respond to `#size`. Until now we have seen strings and arrays being analysed by this validation, but there is another interesting usage: files.

When a user uploads a file, the web server sets an instance of `Tempfile`, which responds to `#size`. That means we can validate the weight in bytes of file uploads.

```ruby
MEGABYTE = 1024 ** 2

required(:avatar) { size?(1..(5 * MEGABYTE)) }
```
