---
title: Announcing Hanami v1.2.0.beta1
date: 2018-02-28 17:05 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  HTTP/2 Early Hints, Unobtrusive JavaScript (UJS), new error page based on <code>better_errors</code>, CLI hooks, project middleware, enhanced support for plugins, bug fixes.
---

Hello wonderful community!

Today we're happy to announce `v1.2.0.beta1` release 🙌 , with the stable release (`v1.2.0`) scheduled for **April 2018**.

## Features

So what this cold winter ❄ has brought to you from the Hanami world?

### HTTP/2 Early Hints

I experimented with [HTTP/2 Push Promise](https://en.wikipedia.org/wiki/HTTP/2_Server_Push) in the summer of 2015, when Hanami was still called [Lotus](/blog/2016/01/22/lotus-is-now-hanami.html). I presented the results at the [RubyDay of that year](https://www.youtube.com/watch?v=XCgsXUKLsOc&feature=youtu.be&t=31m4s) and build a [demo app](https://github.com/jodosha/instants).

We didn't ship that feature because Rack and web servers didn't support Push Promise, so I had to write [a toy HTTP/2 web server for Rack](https://github.com/jodosha/panther).

Given the adoption of HTTP/2 is slow, the IETF _"backported"_ this feature to HTTP/1.
This feature today is known as [Early Hints (103)](https://tools.ietf.org/html/draft-ietf-httpbis-early-hints) status code.

A web application can tell the browser which resources to fetch in advance in order to boost the page loading.

Given that now Rack and [Puma support](https://github.com/puma/puma/pull/1403) Early Hints (103) and we had already in place the code to support this kind of feature, we're excited to release it today!

#### Setup

In order to use it, you need to use Puma with Early Hints feature enabled.

```ruby
# config/puma.rb
# ...
early_hints true
```

Inside the project configuration you can simply enable like this:

```ruby
# config/environment.rb
Hanami.configure do
  # ...
  early_hints true
end
```

As last step, you need a web server that supports HTTP/2 and Early Hints like [h2o](https://h2o.examp1e.net/).
When you'll start the server and visit the page, javascripts and stylesheets will be pushed.

If you're looking for a full working example, please check this [demo app](https://github.com/jodosha/hall_of_fame).

### Unobtrusive JavaScript (UJS)

Today we introduce a new gem in the Hanami family: `hanami-ujs`.

It provides JS features to submit forms and links via AJAX, disable buttons, confirm actions, only with **pure JavaScript**.
`hanami-ujs` is based on the really good [`vanilla-ujs`](https://rubygems.org/gems/vanilla-ujs) gem.

#### Usage

As first thing, you must add `hanami-ujs` to your `Gemfile` and run `bundle install`.

Then you have to add two lines to the application layout (eg. `apps/web/templates/application.html.erb`):

  1. `<%= csrf_meta_tags %>` inside `<head>`
  2. `<%= javascript "hanami-ujs" %>` the location is optional, but before `</body>` is a good spot.

Now we can use the new option for `form_for`: `remote: true`

```erb
<%=
  form_for :search, "/search", remote: true do
    # ...

    submit "Search"
  end
%>
```

When you will push "Search" the form will be sent via AJAX.

### New Development Error Page

New Hanami projects will be generated with a new gem in `Gemfile`: `hanami-webconsole`.

It's is an improved development error page with a built-in REPL to debug Ruby code from the browser.
This feature is based on `better_errors` gem, which historically didn't play well with Hanami.

So we packaged into a Hanami plugin to make the developer experience frictionless.

### CLI hooks

Since `v1.1.0` you can enhance the CLI experience of `hanami` by registering your own commands (eg. `hanami generate webpack` ).
Starting from today you can register callbacks for existing commands to hook into their execution.

Imagine to build a gem `hanami-database-analyzer` to print the number of tables from the development database:

```ruby
Hanami::CLI.after("db migrate") do
  puts "the database has 23 tables"
end
```

When a user will execute `hanami db migrate`, that callback will be called:

```shell
% bundle exec hanami db migrate
# migrations output ...
the database has 23 tables
```

### Project Rack middleware

With this release we're introducing Rack middleware stack at the project level.

```ruby
# config/environment.rb
Hanami.configure do
  middleware.use MyRackMiddleware
end
```

This is equivalent to use a middleware from `config.ru`, the main difference is that the new Rack middleware can be programmatically manipulated by third-party gems (aka plugins). (See the next feature).

### Enhanced support for plugins

Third-party gems (aka plugins) can now manipulate the Hanami configuration of a project.

For instance from the `hanami-webconsole` gem, we [mount](https://github.com/hanami/webconsole/blob/master/lib/hanami/webconsole/plugin.rb) a Rack middleware into the host project:

```ruby
Hanami.plugin do
  middleware.use BetterErrors::Middleware
end
```

### Minor Changes

For the entire list of changes, please have a look at our [CHANGELOG](https://github.com/hanami/hanami/blob/develop/CHANGELOG.md) and [features list](https://github.com/hanami/hanami/blob/develop/FEATURES.md).

## Released Gems

  * `hanami-1.2.0.beta1`
  * `hanami-model-1.2.0.beta1`
  * `hanami-assets-1.2.0.beta1`
  * `hanami-cli-0.2.0.beta1`
  * `hanami-mailer-1.2.0.beta1`
  * `hanami-helpers-1.2.0.beta1`
  * `hanami-view-1.2.0.beta1`
  * `hamami-controller-1.2.0.beta1`
  * `hanami-router-1.2.0.beta1`
  * `hanami-validations-1.2.0.beta1`
  * `hanami-utils-1.2.0.beta1`
  * `hanami-webconsole-0.1.0.beta1`
  * `hanami-ujs-0.1.0.beta1`

## How to try it

```shell
gem install hanami --pre
hanami new bookshelf
```

## What's next?

We'll release new beta versions, with enhancements, and bug fixes.
The stable release is expected on **April 2018**, in the meantime, please try this beta and report issues.

Happy coding! 🌸
