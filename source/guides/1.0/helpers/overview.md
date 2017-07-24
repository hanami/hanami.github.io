---
title: Guides - Helpers Overview
version: 1.0
---

# Overview

A Hanami view is an object that defines presentational logic.
Helpers are modules designed to enrich views with a collection of useful features.

This concept is probably familiar, if you know some Ruby basics.

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

The same simple design is applied to views and helpers.

Hanami ships with default helpers, but we can also define custom helper modules.

## Rendering Context

Views are Ruby objects that are responsible for rendering the associated template.
The context for this activity is defined only by the set of methods that a view can respond to.

If a view has a method `#greeting`, we can use it like this: `<%= greeting %>`.

This design has a few important advantages:

  * It facilitates debugging. In the case of an exception, we know that **the view is the only rendering context to inspect**.
  * Ruby method dispatcher will be **fast**, as it doesn't need to do a lookup for many method sources.

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

Our view responds to `#link_to`, because it includes `Hanami::Helpers::LinkToHelper`, a module that defines that concrete method.

## Clean Context

There are some helpers that have a huge interface.
Think of the [HTML5](/guides/1.0/helpers/html5) or the [routing](/guides/1.0/helpers/routing) helpers, they provide hundreds of methods to map tags or application routes.

Making them available directly in the view context, would be source of confusion, slow method dispatch times and name collisions.

Imagine we have an application with 100 routes.
Because Hanami provides both relative and absolute URI facilities, if used directly, it would mean adding **200 methods** to all the views.
Which is overkill.

For this reason, certain helpers act as a proxy to access these large set of methods.

```erb
<%= routes.home_path %>
```

In this case we have **only one method** to add to our views, but it opens an infinite number of possibilities without causing performance issues.

## Explicit Interfaces

Hanami guides developers to design explicit and intention revealing interfaces for their objects.
Almost all the default helpers, make **private methods** available to our views.

We want to avoid complex expressions that will clutter our templates, and make sure that views remain testable.

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

Helpers aren't mandatory for Hanami applications.
If we want to get rid of them, we just to need to remove two lines of code.

```ruby
# apps/web/application.rb
require 'hanami/helpers' # REMOVE THIS LINE

module Web
  class Application < Hanami::Application
    configure do
      # ...

      view.prepare do
        include Hanami::Helpers # AND THIS ONE
      end
    end
  end
end
```
