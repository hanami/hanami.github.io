---
title: Guides - View Layouts
---

# Layouts

Layouts are special views.
Their role is to render the _"fixed"_ part of the HTML markup that doesn't change from page to page.
Think of the navigation, sidebar, header, footer, etc..

When we generate a new application, there is a default layout called `Web::Views::ApplicationLayout` with a `apps/web/templates/application.html.erb` template.
It comes with a really basic HTML5 wireframe.

```erb
<!doctype HTML>
<html>
  <head>
    <title>Web</title>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```

The interesting part is `<%= yield %>`.
It's replaced at the runtime with the output of a view.
**The order for a rendering is view first, layout as second step.**

The context for a layout template is made of the layout and the current view.
The latter has higher priority.

Imagine to have the following line `<title><%= page_title %></title>`.
If both the layout and the view implement `#page_title`, Hanami will use the one from the view.

## Configure Layout

Default layout is defined in application's configuration.

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
Hanami transforms layout name in application's configuration, by appending the <code>Layout</code> suffix. Eg. <code>:application</code> for <code>Web::Views::ApplicationLayout</code>.
</p>

If we want to disable a layout for a view, we can use a DSL for that.

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

Sometimes it's useful to have more than one layout. For example, if the `application.html.erb` template contains navigation elements, and you want an entirely different layout - without navigation - for a login page, you can create a `login.html.erb` layout template.

Assuming you have created something like a `user_sessions#new` action to log a user in, you create the `login.html.erb` template right next to your default `application.html.erb` in `apps/web/templates/`.

We now need to create a new `Web::Views::LoginLayout` object to utilize the new template. Create a `login_layout.rb` right next to default `application_layout.rb` in `apps/web/views`:

```ruby
module Web
  module Views
    class LoginLayout
      include Web::Layout
    end
  end
end
```

Now, in your `app/web/views/user_sessions.rb` you can specify you'd like to use the login layout for this View:

```ruby
module Web::Views::UserSessions
  class Login
    include Web::View
    layout :login
  end
end
```

Now, only `user_sessions#new` will use the special layout, but you can now use `layout :login` in any other View in this app.

## Optional Content

There are some cases when we want to render a content only for certain resources.
Think of some javascripts to include only in specific pages.

Given the following template for a layout:

```erb
<!doctype HTML>
<html>
  <!-- ... -->
  <body>
    <!-- ... -->
    <footer>
      <%= local :javascripts %>
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

    def javascripts
      raw %(<script src="/path/to/script.js"></script>)
    end
  end
end
```

The first view doesn't respond to `#javascripts`, so it safely ignores it.
Our second object (`Web::Views::Books::Show`) responds to that method, so the result will be included in the final markup.
