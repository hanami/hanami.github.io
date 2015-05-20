---
title: Lotus - Guides - View Layouts
---

# Layouts

Layouts are special views.
Their role is to render the _"fixed"_ part of the HTML markup doesn't change from page to page.
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
If both the layout and the view implement `#page_title`, Lotus will use the one from the view.

## Configure Layout

Default layout is defined in application's configuration.

```ruby
# apps/web/application.rb
module Web
  class Application < Lotus::Application
    configure do
      layout :application
    end
  end
end
```

<p class="convention">
Lotus transform layout name in application's configuration, by appending the <code>Layout</code> suffix. Eg. <code>:application</code> for <code>Web::Views::ApplicationLayout</code>.
</p>

If we want to disable a layout for a view, we can use a DSL for that.

```ruby
# apps/web/views/dashboard/index.rb
module Web::Views::Dashboard
  class Index
    include Web::View
    layout nil
  end
end
```

If we want to turn off this feature entirely, we can set `layout nil` into the application's configuration.

## Content For
