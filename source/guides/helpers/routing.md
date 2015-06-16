---
title: Lotus - Guides - Routing Helpers
---

## Overview

Routing helpers are made of one **public method** (`#routes`), available for actions, views and templates.
It's a factory to generate **relative** or **absolute URLs**, starting from [named routes](/guides/routing/basic-usage).

<p class="convention">
  For a given route named <code>:home</code>, we can use <code>home_path</code> or <code>home_url</code> to generate relative or absolute URLs, respectively.
</p>

## Usage

Imagine we have the following routes for our application:

```ruby
# web/apps/config/routes.rb
get '/',    to: 'home#index', as: :home
get '/foo', to: 'foo#index'

resources :books
```

### Relative URLs

We can do:

```erb
<ul>
  <li><a href="<%= routes.home_path %>">Home</a></li>
  <li><a href="<%= routes.book_path %>">Books</a></li>
</ul>
```

Which generates:

```html
<ul>
  <li><a href="/">Home</a></li>
  <li><a href="/books">Books</a></li>
</ul>
```

We can't link `/foo`, because it isn't a named route (it lacks of the `:as` option).

### Absolute URLs

```ruby
module Web::Controllers::Books
  class Create
    include Web::Action

    def call(params)
      # ...
      redirect_to routes.book_url(id: book.id)
    end
  end
end
```

In the case above, we have passed a Hash as set of params that are required to generate the URL.
