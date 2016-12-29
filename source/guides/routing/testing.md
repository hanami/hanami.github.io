---
title: Guides - Routing Testing
---

# Testing

Hanami has builtin facilities for routing unit tests.

## Path Generation

We can assert the generated routes, to do so, we're gonna create a spec file for the purpose.
`Web.routes` is the class that holds all the routes for the application named `Web`.

It exposes a method to generate a path, which takes the [name of a route](/guides/routing/basic-usage#named-routes) as a symbol.
Here's how to test it.

```ruby
# spec/web/routes_spec.rb
RSpec.describe Web.routes do
  it 'generates "/"' do
    actual = described_class.path(:root)
    expect(actual).to eq '/'
  end

  it 'generates "/books/23"' do
    actual = described_class.path(:book, id: 23)
    expect(actual).to eq '/books/23'
  end
end
```

## Route Recognition

We can also do the opposite: starting from a fake Rack env, we can assert that the recognized route is correct.

```ruby
# spec/web/routes_spec.rb
RSpec.describe Web.routes do

  # ...

  it 'recognizes "GET /"' do
    env   = Rack::MockRequest.env_for('/')
    route = described_class.recognize(env)

    expect(route).to be_routable

    expect(route.path).to   eq '/'
    expect(route.verb).to   eq 'GET'
    expect(route.params).to eq({})
  end

  it 'recognizes "PATCH /books/23"' do
    env   = Rack::MockRequest.env_for('/books/23', method: 'PATCH')
    route = described_class.recognize(env)

    expect(route).to be_routable

    expect(route.path).to   eq '/books/23'
    expect(route.verb).to   eq 'PATCH'
    expect(route.params).to eq(id: '23')
  end

  it 'does not recognize unknown route' do
    env   = Rack::MockRequest.env_for('/foo')
    route = subject.recognize(env)

    expect(route).to_not be_routable
  end
end
```

When we use `.recognize`, the router returns a recognized route, which is an object designed only for testing purposes.
It carries on all the important information about the route that we have hit.
