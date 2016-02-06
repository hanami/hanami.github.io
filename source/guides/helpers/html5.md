---
title: Hanami | Guides - HTML5 Helpers
---

## HTML5 Helpers

This helper makes available an HTML5 generator that is **template engine independent**.
It's a **private method for views and layouts** called `#html`.

## Usage

This is how it will look used with a layout:

```ruby
module Web::Views
  class ApplicationLayout
    include Web::Layout

    def sidebar
      html.aside(id: 'sidebar') do
        div 'hello'
      end
    end
  end
end
```

```erb
<%= sidebar %>
```

It generates:

```html
<aside id="sidebar">
  <div>hello</div>
</aside>
```

## Features

  * It knows how to close tags according to HTML5 spec (1)
  * It accepts content as first argument (2)
  * It accepts builder as first argument (3)
  * It accepts content as block which returns a string (4)
  * It accepts content as a block with nested markup builders (5)
  * It builds attributes from given hash (6)
  * it combines attributes and block (7)

```ruby
# 1
html.div # => <div></div>
html.img # => <img>

# 2
html.div('hello') # => <div>hello</div>

# 3
html.div(html.p('hello')) # => <div><p>hello</p></div>

# 4
html.div { 'hello' }
# =>
#<div>
#  hello
#</div>

# 5
html.div do
  p 'hello'
end
# =>
#<div>
#  <p>hello</p>
#</div>

# 6
html.div('hello', id: 'el', 'data-x': 'y') # => <div id="el" data-x="y">hello</div>

# 7
html.div(id: 'yay') { 'hello' }
# =>
#<div id="yay">
#  hello
#</div>
```

It supports complex markup constructs, **without the need of concatenate tags**. In the following example, there are two `div` tags that we don't need link together.

```ruby
html.section(id: 'container') do
  div(id: 'main') do
    p 'Main content'
  end
  
  div do
    ul(id: 'languages') do
      li 'Italian'
      li 'English'
    end
  end
end

# =>
#  <section id="container">
#    <div id="main">
#      <p>Main Content</p>
#    </div>
#
#    <div>
#      <ul id="languages">
#        <li>Italian</li>
#        <li>English</li>
#      </ul>
#    </div>
#  </section>
```

The result is a very clean Ruby API.

## Custom tags

Hanami helpers support 100+ most common tags, such as `div`, `video` or `canvas`. 
However, HTML5 is fast moving target so we wanted to provide an open interface to define **new or custom tags**.

The API is really simple: `#tag` must be used for a self-closing tag, where `#empty_tag` does the opposite.

```ruby
html.tag(:custom, 'Foo', id: 'next') # => <custom id="next">Foo</custom>
html.empty_tag(:xr, id: 'next')      # => <xr id="next">
```

## Other helpers

Hanami html helpers also support other assembled helpers. For example `link_to` helper:

```ruby
html.div do
  link_to 'hello', routes.root, class: 'btn'
end
# => <div>
# =>   <a href="/" class="btn">hello</a>
# => </div>
```

## Auto escape

The tag contents are automatically escaped for **security** reasons:

```ruby
html.div('hello')         # => <div>hello</hello>
html.div { 'hello' }      # => <div>hello</hello>
html.div(html.p('hello')) # => <div><p>hello</p></hello>
html.div do
  p 'hello'
end # => <div><p>hello</p></hello>



html.div("<script>alert('xss')</script>")
  # =>  "<div>&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;</div>"

html.div { "<script>alert('xss')</script>" }
  # =>  "<div>&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;</div>"

html.div(html.p("<script>alert('xss')</script>"))
  # => "<div><p>&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;</p></div>"

html.div do
  p "<script>alert('xss')</script>"
end
  # => "<div><p>&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;</p></div>"
```

**HTML attributes aren't automatically escaped**, in case we need to use a value that comes from a user input, we suggest to use `#ha`, which is the escape helper designed for this case. See [Escape Helpers](`/guides/helpers/escape`) for a deep explanation.

## View Context

Local variables from views are available inside the nested blocks of HTML builder:

```ruby
module Web::Views::Books
  class Show
    include Web::View

    def title_widget
      html.div do
        h1 book.title
      end
    end
  end
end
```

```erb
<div id="content">
  <%= title_widget %>
</div>
```

```html
<div id="content">
  <div>
    <h1>The Work of Art in the Age of Mechanical Reproduction</h1>
  </div>
</div>
```

