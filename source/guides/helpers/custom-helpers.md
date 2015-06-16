---
title: Lotus - Guides - Custom Helpers
---

## Overview

In the [overview](/guides/helpers/overiew) section, we introduced the design for helpers.
They are modules that enrich views behaviors.
Because they are just Ruby modules, **we can create our own helpers**.

### Example

Imagine we need (for some reason) a helper that shuffles the characters of a string and we want it to be available in our views.

As first thing, let's define the module.

```ruby
# app/web/helpers/shuffler.rb
module Web
  module Helpers
    module Shuffler
      private
      SEPARATOR = ''.freeze

      def shuffle(string)
        string.encode(Encoding::UTF_8, invalid: :replace).
          split(SEPARATOR).shuffle.join
      end
    end
  end
end
```

<p class="notice">
  There is NO convention between the file name and the name of the module.
  We can define this code, where and how we want.
</p>

Then let's add that directory to the load paths of the application, so it can be eagerly loaded.
As third step, we include the module in all the views. See [View's Share Code](/guides/actions/share-code.md) section for low level details.

```ruby
# apps/web/application.rb
module Web
  class Application < Lotus::Application
    configure do
      # ...

      load_paths << [
        'controllers',
        'views',
        'helpers'
      ]

      # ...

      view.prepare do
        include Lotus::Helpers
        include Web::Helpers::Shuffler
      end
    end
  end
end
```

<p class="notice">
  Please note that our custom helper will work even if we remove <code>include Lotus::Helpers</code> line, because it's just Ruby.
</p>
