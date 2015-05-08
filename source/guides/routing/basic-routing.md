---
title: Lotus - Guides - Basic Routing
---

# Basic Routing

In [our initial example](/guides/router/introduction) we have introduced a really basic relative URI: `/`.
This is what we call a _fixed path matching_.
The reason is that the segment is responsible to respond only to the **exact match**.
If we visit `/`, we get a response.
If we hit `/foo`, a `404` (Not Found) is returned.

### Fixed Matching

```ruby
run Lotus::Router.new {
  get '/lotus', to: ->(env) { [200, {}, ['Hello from Lotus!']] }
}

__END__

# curl http://localhost:2300/
# => Hello from Lotus!
```

### Variables

When we have dynamic content to serve, we want our URI to be dynamic as well.
This can be easily achieved via path variables.
They are defined with a colon, followed by a name (eg. `:id`).

Once an incoming request is forwarded to our endpoint, we can access the current value from the Rack env.

```ruby
endpoint = ->(env) {
  [200, {}, ["Hello from Flower no. #{ env['router.params'][:id] }!"]]
}

run Lotus::Router.new {
  router.get '/flowers/:id', to: endpoint
}

__END__

# curl http://localhost:2300/flowers/1
# => Hello from Flower no. 1!
```


### Variables Constraints

It's possible to specify constraints for each variable.
The rule must be expressed as a regular expression.
If an request can't satisfy at least one of them, a `404` is returned.

```ruby
endpoint = ->(env) {
  [200, {}, [":id is a number: #{ env['router.params'][:id] }!"]]
}

run Lotus::Router.new {
  router.get '/flowers/:id', id: /\d+/, to: endpoint
}

__END__

# curl http://localhost:2300/flowers/1
# => :id is a number: 1!
```

### Optional tokens

Sometimes we want to specify an optional token as part of our URI.
It should be expressed between round parenthesis.
If present, it will be available as param in the Rack env, otherwise it will be missing, but the endpoint will be still hit.

```ruby
endpoint = ->(env) {
  [200, {}, ["You have requested #{ env['router.params'][:format] } format"]]
}

run Lotus::Router.new {
  router.get '/flowers(.:format)', to: endpoint
}

__END__

# curl http://localhost:2300/flowers.json
# => You have requested json format
```

### Wildcard matching

Imagine to serve static files from a user repository.
It would be impossible to know in advance which files are stored and to prepare routes accordingly.

To solve this problem, Lotus::Router supports wildcard matching.

```ruby
endpoint = ->(env) {
  [200, {}, ["Path: /#{ env['router.params'] }"]]
}

run Lotus::Router.new {
  router.get '/files/*', to: endpoint
}

__END__

# curl http://localhost:2300/files/path/to/my/file.png
# => Path: /path/to/my/file.png
```
