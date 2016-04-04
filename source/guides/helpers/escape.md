---
title: Guides - Markup Escape Helpers
---

## Markup Escape Helpers

**Views escape automatically the output of their methods.**
There are complex situations that views can't cover properly and that require an extra attention from us.

Hanami makes available a set of escape helpers, to increase the security of our web applications.
They are **public methods** that are available both in views and templates.

## Escape HTML Contents

It's a method called `#escape_html` (aliased as `#h`), that escapes the input.

```erb
<p><%= h "<script>alert('xss')</script>" %></p>
```

Returns

```html
<p>&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;</p>
```

## Escape HTML Attributes

HTML attributes are more complex to escape, because they involve attribute delimitation chars (eg. single or double quotes).

We have an extra helper for this specific task: `#escape_html_attribute` (aliased as `#ha`)
**This should be used only when the value of an attribute comes from a user input.**

```erb
<img="/path/to/avatar.png" title="<%= ha(user.name) %>'s Avatar">
```

## Whitelisted URLs

Imagine we have a feature in our application that allows users to link from their profile, a website.
In the edit profile form we have a text field that accepts a URL.

In the profile page we have a link like this:

```erb
<%= link_to "Website", user.website_url %>
```

A malicious user can edit their profile, by entering javascript code as the website URL.
When somebody else clicks on that link, they can receive an XSS attack.

Example:

```html
<a href="javascript:alert('hack!');">Website</a>
```

The solution to this problem is to wrap the output with the `#escape_url` (aliased as `#hu`) helper.

It whitelists URLs that use `http`, `https`, and `mailto` schemes, everything else is scraped.

```erb
<%= link_to "Website", hu(user.website_url) %>
```

In case we need a different set of schemes, we can specify them as second argument.

```erb
<%= link_to "Website", hu(user.website_url, ['https']) %>
```

In the code above, we're restricting to URLs that only use HTTPS.

## Raw Contents

There are cases when we want to print the raw contents.
**Please be careful with this, because unescaped contents can open a breach for XSS attacks.**

The helper is called `#raw`.

```ruby
# apps/web/views/books/json_show.rb
require 'json'

module Web::Views::Books
  class JsonShow < Show
    format :json

    def render
      raw JSON.generate(book.to_h)
    end
  end
end
```
