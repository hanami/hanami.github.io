---
title: Guides - Views Basic Usage
version: 1.2
---

# Basic Usage

In the [previous section](/guides/1.2/views/overview) we generated a view. Let's use it.

## Default Rendering

First, we edit the corresponding template:

```erb
# apps/web/templates/dashboard/index.html.erb
<h1>Dashboard</h1>
```

By visiting `/dashboard`, we should see `<h1>Dashboard</h1>` in our browser.

Again we should look at the naming convention.
Our view is `Web::Views::Dashboard::Index`, while the file name of the template is `web/templates/dashboard/index`.

<p class="convention">
  For a given view <code>Web::Views::Dashboard::Index</code>, the corresponding template MUST be available at <code>apps/web/templates/dashboard/index.html.erb</code>.
</p>

### Context

While rendering a template, variable lookups requested by the template go to a view _context_.

```erb
# apps/web/templates/dashboard/index.html.erb
<h1><%= title %></h1>
```

If we amend our template by adding an interpolated variable, the view is responsible for providing it.

```ruby
# apps/web/views/dashboard/index.rb
module Web::Views::Dashboard
  class Index
    include Web::View

    def title
      'Dashboard'
    end
  end
end
```

The view now responds to `#title` by implementing it as a concrete method.
We still see `<h1>Dashboard</h1>` when we visit `/dashboard`.

### Exposures

There is another source for our context: [_exposures_](/guides/1.2/actions/exposures).
They are a payload that comes from the action.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action
    expose :title

    def call(params)
      @title = 'Dashboard'
    end
  end
end
```

We can remove `#title` from our view, to get the same output when accessing `/dashboard`.

```ruby
# apps/web/views/dashboard/index.rb
module Web::Views::Dashboard
  class Index
    include Web::View
  end
end
```

<p class="notice">
Rendering context for a template is made of view methods and exposures.
</p>

The objects exposed in the controller action are available in the corresponding view. So the values 
can also be modified, wrapped or reused in some other way. Assuming that the `title` is exposed
in the action, it can be accessed as follows:

```ruby
# apps/web/views/dashboard/index.rb
module Web::Views::Dashboard
  class Index
    include Web::View
    
    def full_title
      "The title: " + title
     end
  end
end
```

## Custom Rendering

Hanami performs rendering by calling `#render` on a view and it expects a string in return.
The benefit of an object-oriented approach is the ability to easily diverge from default behavior.

We can override that method to define a custom rendering policy.

```ruby
# apps/web/views/dashboard/index.rb
module Web::Views::Dashboard
  class Index
    include Web::View

    def render
      raw %(<h1>Dashboard</h1>)
    end
  end
end
```

Once again our output is still the same, but the template isn't used at all.

<p class="convention">
If a view overrides <code>#render</code> the output MUST be a string that will be the body of the response.
The template isn't used and it can be deleted.
</p>

## Bypass Rendering

If an action assigns the body of the response with `#body=`, the rendering of the view is [bypassed](/guides/1.2/actions/basic-usage).
