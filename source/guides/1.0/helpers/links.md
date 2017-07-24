---
title: Guides - Link Helpers
version: 1.0
---

## Link Helpers

It provides a concise API to generate links.
It's a **public method** called `#link_to`, that can be used both in **views** and **templates**.

## Usage

It accepts two mandatory and one optional arguments.
The first is the content of the tag, the second is the path, an the third is a Hash that represents a set of HTML attributes that we may want to specify.

```erb
<%= link_to 'Home', '/' %>
<%= link_to 'Profile', routes.profile_path, class: 'btn', title: 'Your profile' %>
<%=
  link_to(routes.profile_path, class: 'avatar', title: 'Your profile') do
    img(src: user.avatar.url)
  end
%>
```

Output:

```html
<a href="/">Home</a>
<a href="/profile" class="btn" title="Your profile">Profile</a>
<a href="/profile" class="avatar" title="Your profile">
  <img src="/images/avatars/23.png">
</a>
```

Alternatively, the content can be expressed as a given block.

```ruby
module Web::Views::Books
  class Show
    include Web::View

    def look_inside_link
      url = routes.look_inside_book_path(id: book.id)

      link_to url, class: 'book-cover' do
        html.img(src: book.cover_url)
      end
    end
  end
end
```

Template:

```erb
<%= look_inside_link %>
```

Output:

```html
<a href="/books/1/look_inside" class="book-cover">
  <img src="https://cdn.bookshelf.org/books/1/full.png">
</a>
```

## Security

There are two aspects to consider when we use links in our markup: **whitelisted URLs** and **escaped attributes**.
Please visit the [Markup Escape](/guides/1.0/helpers/escape) section for a detailed explanation.
