---
title: Lotus - Guides - Helpers Overview
---

# Overview

A Lotus view in an object that defines presentational logic.
Helpers are modules designed to enrich views with a collection of useful features.

Lotus ships with default included helpers, but we can define custom modules to add.

## Rendering Context

Views are Ruby objects that are responsible to render the associated template.
The context for this activity is defined only by the set of methods that a view can respond to.

If a view has a method `#greeting`, we can use it like this: `<%= greeting %>`.

This design has a few but important advantages:

  * It facilitates debugging. In case of exception, we know that **the view is the only rendering context to inspect**.
  * Ruby method dispatcher will be **fast**, as it doesn't need to lookup for many method sources.

Consider the following code:

```ruby
# apps/web/views/books/show.rb
module Web::Views::Books
  include Web::View

  def home_page_link
    link_to "Home", "/"
  end
end
```

Our view responds to `#link_to`, because it includes `Lotus::Helpers::LinkToHelper`, a module that defines that concrete method.

## Explicit Interfaces

Lotus guides developers to design explicit and intention revealing interfaces for their objects.
Almost all the default helpers, make available **private methods** to our views.

We want to avoid that complex expression will clutter our templates, and make sure that views will remain testable.

Here an example of **poor** and **untestable** code in a template.

```erb
<%= format_number book.downloads_count %>
```

If we want to unit test this logic, we can't do it directly, unless we render the template and match the output.

For this reason `#format_number`, is shipped as a private method, so we are forced to define an explicit method for our interface.

```ruby
# apps/web/views/books/show.rb
module Web::Views::Books
  include Web::View

  def downloads_count
    format_number book.downloads_count
  end
end
```

To be used like this:

```erb
<%= downloads_count %>
```

This version is **visually simpler** and **testable**.
