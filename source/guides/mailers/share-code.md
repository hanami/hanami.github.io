---
title: Guides - Mailes Share Code
---

# Share Code

## Prepare

In our settings (`lib/bookshelf.rb`), there is code block that allows to share the code for **all the mailers** of our application.
When a mailer includes the `Hanami::Mailer` module, that block code is yielded within the context of that class.
This is heavily inspired by Ruby Module and its `included` hook.

Imagine we want to set a default sender for all the mailers.
Instead of specifying it for each mailer, we can use a DRY approach.

We create a module:

```ruby
# lib/mailers/default_sender.rb
module Mailers::DefaultSender
  def self.included(mailer)
    mailer.class_eval do
      from 'sender@bookshelf.org'
    end
  end
end
```

Then we include in all the mailers of our application, via `prepare`.

```ruby
# lib/bookshelf.rb
# ...

Hanami.configure do
  # ...
  mailer do
    root 'lib/bookshelf/mailers'

    # See http://hanamirb.org/guides/mailers/delivery
    delivery :test
    
    prepare do
      include Mailers::DefaultSender
    end
  end
end
```

<p class="warning">
Code included via <code>prepare</code> is available for ALL the mailers of an application.
</p>

