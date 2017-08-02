---
title: Guides - View Layouts
version: 1.0
---

# Layouts

Layouts are special views, that render the _"fixed"_ part of the HTML markup.
This is the part that doesn't change from page to page (perhaps navigation, sidebar, header, footer, etc.)

When we generate a new application, there is a default layout called `Web::Views::ApplicationLayout` with a `apps/web/templates/application.html.erb` template.
It comes with a very basic HTML5 wireframe.

```erb
<!DOCTYPE HTML>
<html>
  <head>
    <title>Web</title>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```

The most interesting part is `<%= yield %>`.
It's replaced at the runtime with the output of a view.
**The order for rendering is first the view, and then the layout.**

The context for a layout template is made of the layout and the current view.
The latter has higher priority.

Imagine having the following line `<title><%= page_title %></title>`.
If both the layout and the view implement `page_title`, Hanami will use the one from the view.

## Configure Layout

The default layout is defined in an application's configuration.

```ruby
# apps/web/application.rb
module Web
  class Application < Hanami::Application
    configure do
      layout :application
    end
  end
end
```

<p class="convention">
Hanami transforms the layout name in the application's configuration, by appending the <code>Layout</code> suffix. For example, <code>layout :application</code> corresponds to <code>Web::Views::ApplicationLayout</code>.
</p>

If we want to disable a layout for a view, we can use a DSL for that:

```ruby
# apps/web/views/dashboard/index.rb
module Web::Views::Dashboard
  class Index
    include Web::View
    layout false
  end
end
```

If we want to turn off this feature entirely, we can set `layout nil` into the application's configuration.

## Using Multiple Template Layouts

Sometimes it's useful to have more than one layout.
For example, if the `application.html.erb` template contains navigation elements, and we want an entirely different layout, without navigation elements, for a login page, we can create a `login.html.erb` layout template.

Assuming we have a `Web::Actions::UserSessions::New` action to log a user in, we can create a `login.html.erb` template right next to the default `application.html.erb` in `apps/web/templates/`.

Then we need to create a new `Web::Views::LoginLayout` class, which will use the new layout template. This file can be named `app/web/views/login_layout.rb`(right next to the default `application_layout.rb`):

```ruby
module Web
  module Views
    class LoginLayout
      include Web::Layout
    end
  end
end
```

Now, in our `app/web/views/user_sessions/new.rb` we can specify you'd like to use the login layout for this View:

```ruby
module Web::Views::UserSessions
  class New
    include Web::View
    layout :login
  end
end
```

And we can add `layout :login` to any other View in this app that should use this same layout.

## Optional Content

Sometimes it's useful to render content only on certain pages.
For example, this could be used to have page-specific javascript.

Given the following template for a layout:

```erb
<!DOCTYPE HTML>
<html>
  <!-- ... -->
  <body>
    <!-- ... -->
    <footer>
      <%= local :javascript %>
    </footer>
  </body>
</html>
```

With following views:

```ruby
module Web::Views::Books
  class Index
    include Web::View
  end
end
```

and

```ruby
module Web::Views::Books
  class Show
    include Web::View

    def javascript
      raw %(<script src="/path/to/script.js"></script>)
    end
  end
end
```

The first view doesn't respond to `#javascript`, so it safely ignores it.
Our second object (`Web::Views::Books::Show`) responds to that method, so the result will be included in the final markup.
