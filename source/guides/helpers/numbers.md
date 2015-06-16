---
title: Lotus - Guides - Number Helpers
---

## Overview

Lotus offers a helpful way to present numbers via `#format_number`, a **private method** available only in views.

## Usage

```ruby
module Web::Views::Books
  class Show
    include Web::View

    def download_count
      format_number book.download_count
    end
  end
end
```

```erb
<span><%= download_count %></span>
```

```html
<span>1,000,000</span>
```

### Precision

The default precision is of `2`, but we can specify a different value with the homonym option.

```ruby
format_number(Math::PI)               # => "3.14"
format_number(Math::PI, precision: 6) # => "3.141592"
```

### Delimiter

The default thousands delimiter is `,`. We can use `:delimiter` for a different char.

```ruby
format_number(1_000_000)                 # => "1,000,000"
format_number(1_000_000, delimiter: '.') # => "1.000.000"
```

### Separator

The default separator is `.`. We can use `:separator` for a different char.

```ruby
format_number(1.23)                 # => "1.23"
format_number(1.23, separator: ',') # => "1,23"
```
