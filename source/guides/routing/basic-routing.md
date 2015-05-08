---
title: Lotus - Guides - Basic Routing
---

# Basic Routing

## Path matching

In [our initial example](/guides/routing/overview) we have introduced a really basic relative URI: `/hello`.
This is what we call a _fixed path matching_.
The reason is that the segment is responsible to respond only to the **exact match**.
If we visit `/hello`, we get a response.
If we hit `/foo`, a `404` (Not Found) is returned.

### Fixed Matching

```ruby
get '/dashboard', to: "dashboard#index"
```

### Variables

When we have dynamic content to serve, we want our URI to be dynamic as well.
This can be easily achieved via path variables.
They are defined with a colon, followed by a name (eg. `:id`).

Once an incoming request is forwarded to our endpoint, we can access the current value in our param's action (`params[:id]`).

```ruby
get '/books/:id', to: 'books#show'
```

Multiple variables can be used in a path.

```ruby
get '/books/:book_id/reviews/:id', to: 'reviews#show'
```

### Variables Constraints

It's possible to specify constraints for each variable.
The rule MUST be expressed as a regular expression.
If a request can satisfy all of them, we're good, otherwise a `404` is returned.

```ruby
get '/authors/:id', id: /\d+/, to: 'authors#show'
```

### Optional Tokens

Sometimes we want to specify an optional token as part of our URI.
It should be expressed between round parenthesis.
If present, it will be available as param in the Rack env, otherwise it will be missing, but the endpoint will be still hit.

```ruby
get '/books(.:format)', to: 'books#show'
```

### Wildcard Matching

Imagine to serve static files from a user repository.
It would be impossible to know in advance which files are stored and to prepare routes accordingly.

To solve this problem, Lotus supports _wildcard matching_.

```ruby
get '/files/*', to: 'files#show'
```

## Named Routes

We can specify an unique name for each route, in order to generates paths from the router or to test them.

```ruby
get '/hello',     to: 'greet#index', as: :greeting
get '/books/:id', to: 'books#show',  as: :book
```

When a Lotus application starts, it generates a Ruby module at the runtime under our application namespace: eg. `Web::Routes`.
We can use it to generate a relative or absolute URI for our route.

```ruby
Web::Routes.path(:greeting) # => "/hello"
Web::Routes.url(:greeting)  # => "http://localhost:2300/hello"
```

When we have one or more variables, they can be specified as a Hash.

```ruby
Web::Routes.path(:book, id: 1) # => "/books/1"
Web::Routes.url(:book, id: 1)  # => "http://localhost:2300/books/1"
```

Absolute URL generation is dependent on `scheme`, `host` and `port` settings in `apps/web/application.rb`.

### Routing Helpers

Generating routes from `Web::Routes` is helpful, because that module can be accessed from everywhere.
However, this syntax is noisy.

Lotus has _routing helpers_ available as `routes` in: **actions**, **views** and **templates**.

```ruby
<%= routes.path(:greeting) %>
<%= routes.url(:greeting) %>
```

Or

```ruby
<%= routes.greeting_path %>
<%= routes.greeting_url %>
```

## Namespaces

If we want to group a set of resources under a common prefix we can use `namespace`.

```ruby
namespace 'docs' do
  get '/installation', to: 'docs#installation'
  get '/usage',        to: 'docs#usage'
end

# This will generate:
#
#   /docs/installation
#   /docs/usage
```

## Redirects

In case of legacy routes, we can handle HTTP redirects at the routing level.

```ruby
redirect '/old', to: '/new'
```
