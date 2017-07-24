---
title: Guides - View Share Code
version: 1.0
---

# Share Code

## Prepare

In our settings (`apps/web/application.rb`), there is a code block that allows to share the code for **all the views** of our application.
When a view includes the `Web::View` module, that block code is yielded within the context of that class.
This is heavily inspired by Ruby Module and its `included` hook.

Imagine we have an application that only renders JSON.
For each view we should specify the handled format. This can be tedious to do by hand, but we can easily DRY our code.

We craft a module in `apps/web/views/accept_json.rb`.

```ruby
# apps/web/views/accept_json.rb
module Web::Views
  module AcceptJson
    def self.included(view)
      view.class_eval do
        format :json
      end
    end
  end
end
```

Then we can load the file and include the module in **all** the views of our application, using view.prepare.

```ruby
# apps/web/application.rb
require_relative './accept_json'

module Web
  class Application < Hanami::Application
    configure do
      # ...
      view.prepare do
        include Web::Views::AcceptJson
      end
    end
  end
end
```

<p class="warning">
Code included via <code>prepare</code> is available for ALL the views of an application.
</p>
