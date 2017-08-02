---
title: Guides - Routing Overview
version: 1.0
---

# Overview

Hanami applications use [Hanami::Router](https://github.com/hanami/router) for routing: a Rack compatible, lightweight and fast HTTP router for Ruby.

## Getting started

With your favorite editor open `apps/web/config/routes.rb` and add the following line.

```ruby
get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
```

Then start the server with `bundle exec hanami server` and visit [http://localhost:2300/hello](http://localhost:2300/hello).
You should see `Hello from Hanami!` in your browser.

Let's explain what we just did.
We created a **route**; an application can have many routes.
Each route starts with an [HTTP verb](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html) declaration, `get` in our case.
Then we specify a relative URI (`/hello` for us) and the object that is responsible to respond to incoming requests.

We can use most common HTTP verbs: `GET`, `POST`, `PUT`, `PATCH`, `DELETE`, `TRACE` and `OPTIONS`.

```ruby
endpoint = ->(env) { [200, {}, ['Hello from Hanami!']] }

get     '/hello', to: endpoint
post    '/hello', to: endpoint
put     '/hello', to: endpoint
patch   '/hello', to: endpoint
delete  '/hello', to: endpoint
trace   '/hello', to: endpoint
options '/hello', to: endpoint
```

## Rack

Hanami is compatible with [Rack SPEC](http://www.rubydoc.info/github/rack/rack/master/file/SPEC), and so the endpoints that we use MUST be compliant as well.
In the example above we used a `Proc` that was fitting our requirements.

A valid endpoint can be an object, a class, an action, or an **application** that responds to `#call`.

```ruby
get '/proc',       to: ->(env) { [200, {}, ['Hello from Hanami!']] }
get '/action',     to: "home#index"
get '/middleware', to: Middleware
get '/rack-app',   to: RackApp.new
get '/rails',      to: ActionControllerSubclass.action(:new)
```

When we use a string, it tries to instantiate a class from it:

```ruby
get '/rack-app', to: 'rack_app' # it will map to RackApp.new
```

## Actions

Full Rack integration is great, but the most common endpoint that we'll use in our web applications is an **action**.
Actions are objects responsible for responding to incoming HTTP requests.
They have a nested naming like `Web::Controllers::Home::Index`.
This is a really long name to write, that's why Hanami has a **naming convention** for it: `"home#index"`.

```ruby
# apps/web/config/routes.rb
root to: "home#index" # => will route to Web::Controllers::Home::Index
```

The first token is the name of the controller `"home"` is translated to `Home`.
The same transformation will be applied to the name after the `#`: `"index"` to `Index`.

Hanami is able to figure out the namespace (`Web::Controllers`) and compose the full class name.

### Mounting Applications

If we want to mount an application, we should use `mount` within the Hanami environment configuration file. The global configuration file is located at `config/environment.rb`. Place `mount` within the Hanami.configure block.

```ruby
Hanami.configure do
  mount Web::Application, at: '/'
  mount OtherApplication.new, at: '/other'

  ...
end
```

#### Mounting To A Path

```ruby
mount SinatraApp.new, at: '/sinatra'
```

All the HTTP requests starting with `/sinatra` will be routed to `SinatraApp`.

#### Mounting On A Subdomain

```ruby
mount Blog.new, host: 'blog'
```

All the HTTP requests to `http://blog.example.com` will be routed to `Blog`.

<p class="notice">
  In development, you will NOT be able to access <code>http://blog.localhost:2300</code>,
  so you should specify a host when running the server:
  <code>bundle exec hanami server --host=lvh.me</code>.
  Then your application can be visited at <code>http://blog.lvh.me:2300</code>
</p>
