---
title: Introducing Hanami::API
date: 2020-02-26 13:23:35 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  It's a minimal, extremely fast, lightweight Ruby framework for HTTP APIs.
---

In the quest of spreading the Hanami word, I talk to many people.
A recurring pattern emerged from these discussions: the business risk of "switching" to Hanami, which is a relatively "new" technology.
Maybe they want to personally introduce Hanami at their company, but there is the fear of the change.

I understand and respect this feedback, but I believe that people are focusing of the negative side of the story.
Here's my **positive and reassuring** answers.

### New techs

There will always be new technologies that are worth to try.
In a fast paced world, tech companies risk to fall behind.
Developers must be practitioners of the art of coding, it's a must to stay relevant.

This means to pick a few selected technologies and to experiment with them.
If you're working with Python, try Go.
If you are a Rubyist, play with Elixir.
If you use React, build an app with Elm.
You name it.

You will never know if the new tech you're looking at, could be come the next important milestone in our industry.

For those who remember, back in the days, we were trying to sneak in our companies this relatively new language from the far east, known as Ruby.
Fast forwarding to the present, here we are: Ruby is a well established language.

### Iterative adoption

I'm not asking you to convert everything to Hanami, but maybe the next little project that you need to start can use Hanami.

When working on small or greenfield projects, the risk is low, because if something goes wrong, you can always revert to the well known tech.

This iterative adoption approach helps you to discover a new tech, by keeping the risk low.

### There is no switch

If Hanami is great for you, it doesn't have be the only tool at your disposal.
The opposite is true: instead of having only one way to build web apps, **you have multiple options to choose from**.
Each one has its own pros and cons, just pick the one that makes more sense for your next project.

## Introducing `hanami-api`

To make even lower the risk of adopting Hanami, because it's a full stack framework, we build this tiny HTTP framework: `hanami-api`.

It's a minimal, extremely fast, lightweight Ruby framework for HTTP APIs.

Our goal is to allow you to try a smaller part of Hanami and build your own stack.

### Usage

The usage is very simple and familiar for you.
Alongside with the well known [Hanami routing syntax](https://guides.hanamirb.org/routing/overview/), we introduced the _block syntax_.
If you pass a Ruby block to the route definition, then it will be evaluated when an incoming HTTP request will match that route.

Here's a simple `config.ru` file:

```ruby
# frozen_string_literal: true

require "bundler/setup"
require "hanami/api"

class App < Hanami::API
  get "/" do
    "Hello, world"
  end
end

run App.new
```

From the shell you can try it with `bundle exec rackup` and visit the URL of the app.

As mentioned above, you can still use it alongside with existing Hanami components or any other Rack endpoint:

```ruby
# frozen_string_literal: true

require "bundler/setup"
require "hanami/api"
require "hanami/controller"

class MyAction
  include Hanami::Action

  def call(params)
    # ...
  end
end

class App < Hanami::API
  get "/", to: ->(*) { [200, {}, ["OK"]] }
  get "/foo", to: MyAction
end

run App.new
```

### Performance

Benchmark against an app with 10,000 routes, hitting the 10,000th to measure the worst case scenario.
Based on [`jeremyevans/r10k`](https://github.com/jeremyevans/r10k), `Hanami::API` scores **first for speed and requests per second**, and **second for memory footprint**.

#### Runtime

Runtime to complete 20,000 requests (lower is better).

![Runtime benchmark](/blog/2020/02/26/introducing-hanami-api/runtime.png "Runtime benchmark")

#### Memory

Memory footprint for 10,000 routes app (lower is better).

![Memory benchmark](/blog/2020/02/26/introducing-hanami-api/memory.png "Memory benchmark")

#### Requests per second

Requests per second hitting the 1st and the 10,000th route to measure the best and worst case scenario (higher is better).

![Requests per second benchmark](/blog/2020/02/26/introducing-hanami-api/requests-per-second.png "Requests per second")

## Conclusion

`hanami-api` is simple, low risk, very performant way to try Hanami and build your own Ruby stack.
**It's the ideal mini framework to build HTTP APIs and microservices.**

For more details:

`gem install hanami-api` today and [read the docs](https://github.com/hanami/api/blob/master/README.md) to try it today!

Happy coding! 🌸
