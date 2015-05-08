---
title: Lotus - Guides - Routing Overview
---

# Overview

[Lotus::Router](https://github.com/lotus/router) is a Rack compatible, lightweight and fast HTTP Router for Ruby and Lotus.

## Getting started

Open your favorite editor and write the following lines in `config.ru`.

```ruby
require 'lotus/router'

app = Lotus::Router.new do
  get '/', to: ->(env) { [200, {}, ['Welcome to Lotus::Router!']] }
end

run app
```

Then run `bundle exec rackup --port=2300` and visit [http://localhost:2300](http://localhost:2300).
**Congrats, you wrote your first application with Lotus!**

Lotus is designed to scale from a single endpoint like this to multiple applications in the same Ruby process.

One step at the time.
Let's see what we just did.
We created a `Lotus::Router` instance, the constructor accepts a block that describes our routes.
Each route starts with an [HTTP verb](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html) declaration, `get` in our case.
Then we specify a relative URI (`/`) and the object that is responsible to respond to incoming requests.

## HTTP verbs

We support most common HTTP verbs: `GET`, `POST`, `PUT`, `PATCH`, `DELETE`, `TRACE` and `OPTIONS`.

```ruby
endpoint = ->(env) { [200, {}, ['Hello from Lotus!']] }

run Lotus::Router.new {
  get     '/lotus', to: endpoint
  post    '/lotus', to: endpoint
  put     '/lotus', to: endpoint
  patch   '/lotus', to: endpoint
  delete  '/lotus', to: endpoint
  trace   '/lotus', to: endpoint
  options '/lotus', to: endpoint
}
```
