---
title: Lotus - Guides - Helpers Overview
---

# Overview

A Lotus view in an object that defines presentational logic.
Helpers are modules designed to enrich views with a collection of useful features.

This concept is probably familiar, if we know some Ruby basics.

```ruby
module Printable
  def print
    puts "..."
  end
end

class Person
  include Printable
end

Person.new.print
```

The same simple design is applied for views and helpers.

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

## Clean Context

There are some helpers that have a huge interface.
Think of the [HTML5](/guides/helpers/html5) or the [routing](/guides/helpers/routing) helpers, they provide hundreds of methods to map tags or application routes.

Making them available directly in the view context, would be source of confusion, slow method dispatch times and name collisions.

Imagine we have an application with 100 routes.
Because Lotus provides both relative and abosolute URI facilities, if used directly, that would have mean to add **200 methods** to all the views.
Which is overkilling.

For this reason, certain helpers act as a proxy to access these large set of methods.

```erb
<%= routes.home_path %>
```

In this case we have **only one method** to add to our views, but it opens to infinite possibilities without perf penalties.

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

## Disable Helpers

Helpers aren't mandatory for Lotus applications.
If we want to get rid of them, we just to need to remove two lines of code.

```ruby
# apps/web/application.rb
require 'lotus/helpers' # REMOVE THIS LINE

module Web
  class Application < Lotus::Application
    configure do
      # ...

      view.prepare do
        include Lotus::Helpers # AND THIS ONE
      end
    end
  end
end
```
