---
title: Announcing Lotus v0.4.0
date: 2015-06-23 08:23 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Features: additional architecture, database migrations, HTML5 form helpers, CSRF Protection, Force SSL.
  New Core Team member, Rails Girls Summer of Code and Guides!
---

Before to dive into the details of this release, we want to say **thank you** to our beloved Community.
In a year we went from an initial release with few features and people around Lotus, to a technology that is having an impact on the Ruby ecosystem.

Without you this wouldn't be possible.

## Features

We have listened to developers who are building applications with Lotus, the most two requested features were migrations and form helpers.
They will be happy about today's release.

### Database Migrations

Database migrations is a great way to manage schema for SQL storages.
We have introduced a generator for them and a set of shell commands for database operations.

```shell
% bundle exec lotus generate migration create_books
      create  db/migrations/20150623091551_create_books.rb
```

Let's edit it:

```ruby
Lotus::Model.migration do
  change do
    create_table :books do
      primary_key :id
      foreign_key :author_id, :authors, on_delete: :cascade, null: false

      column :code,  String,  null: false, unique: true, size: 128
      column :title, String,  null: false
      column :price, Integer, null: false, default: 100 # cents

      check { price > 0 }
    end
  end
end
```

We use an API to define schema changes and how to revert them.
Methods like `#create_table`, `#primary_key` or `#column` are intuitive and feels like natural a translation from SQL to Ruby world.

Then we can create and migrate with `lotus db create` and `lotus db migrate`, or use `lotus db prepare` as a shortcut.

[Read the full announcement](/blog/2015/06/17/introducing-database-migrations.html).

### HTML5 Form Helpers

HTML5 forms helpers are a feature that we're really proud to ship today.
They are a powerful Ruby API that **doesn't require to monkey-patch ERb**, they are **template engine independent** and the cleaner code solution for Ruby:

   * Support for complex markup without the need of concatenation
   * Auto closing HTML5 tags
   * Support for view local variables
   * Method override support (`PUT`/`PATCH`/`DELETE` HTTP verbs aren't understood by browsers)
   * Automatic generation of HTML attributes for inputs: `id`, `name`, `value`
   * Allow to override automatic HTML attributes
   * Read values from request params and/or given entities, to autofill `value` attributes
   * Automatic selection of current value for radio button and select inputs
   * CSRF Protection
   * Infinite nested fields
   * ORM Agnostic

Here an example of form to create a book.

```erb
<%=
  form_for :book, routes.books_path, class: 'form-horizontal' do
    div class: 'form-group' do
      label      :title
      text_field :title, class: 'form-control'
    end

    submit 'Create'
  end
%>
```

It produces:

```html
<form action="/books" id="book-form" method="POST" class="form-horizontal">
  <input type="hidden" name="_csrf_token" value="e54fe87c03c8acb84f50826e969df4f00210af315f2e27e064741ecc09155a75">
  <div class="form-group">
    <label for="book-title">Title</label>
    <input type="text" name="book[title]" id="book-title" value="">
  </div>

  <button type="submit">Create</button>
</form>
```

[Read the full announcement](/blog/2015/06/15/introducing-form-helpers.html).

### Application Architecture

Lotus is a modular web framework that can adapt to different scenarios: **from small HTTP endpoints to large applications**.

We apply a great philosophy called [Monolith First](http://martinfowler.com/bliki/MonolithFirst.html).

With our default architecture called [_Container_](/guides/architectures/container), we can host several Lotus and Rack based apps **within the same Ruby process**.
This helps to have fast code iterations when we develop a new product, without worrying about how it will be deployed.
**Microservices are too expensive at the beginning.**

Lotus offers a gentle guidance to build component based softwares.
Each application under `apps/` can be a customer facing UI, admin pane, HTTP API, metrics, etc..

These modules use their own Ruby namespace, so they are ready to be extracted into separate deliverables at the later stages of our product.

While the scenario depicted above helps to assemble large products, we sometimes have the need to add a small application to our existing environment.
With today release we introduce **a new architecture** called: [_Application_](/guides/architectures/application).

```shell
% lotus new admin --arch=app
```

The command above will generate a new application that has a structure similar to Ruby on Rails.

```shell
% tree -L 1
.
├── Gemfile
├── Rakefile
├── app
├── config
├── config.ru
├── db
├── lib
├── public
└── spec

6 directories, 3 files
```

The main difference here is that we still apply [Clean Architecture](https://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html) like we do with _Container_.
That means the core of our application lives in `lib/`.

```shell
% tree lib
lib
├── admin
│   ├── entities
│   └── repositories
├── admin.rb
└── config
    └── mapping.rb

4 directories, 2 files
```

### Security

Lotus commitment for a secure web continues with the introduction of two new features.

#### Force SSL

The first is about SSL.
No one should deploy a product without taking care about the privacy of our users.
Using an encrypted connection is the first step for a safe data transmission.

We now support a mechanism to force secure connections in production environments.

```ruby
# apps/web/application.rb
module Web
  class Application < Lotus::Application
    configure do
      # ...
      force_ssl true
    end
  end
end
```

#### CSRF Protection

The second is a protection against [Cross Site Request Forgery (CSRF)](https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF)) attacks.
This is one of the most common threats for web applications, as of today Lotus apps have a defense mechanism for that.

It's activated automatically when we enable sessions.

### Breaking Changes

We care **a lot** about the stability of our public APIs, because it involves companies investment on Lotus.
Each breaking change is thoughtfully evaluated and we wait for minor releases like this to make developers aware of them.

Designing a large software like Lotus is hard and **we make mistakes**.
Before to hit 1.0, we want to be sure that we have fixed them.

#### Environment Configurations

Until `0.3` environment configurations (`.env`) were placed under `config/` directory.
For compatibility with other tools, now Lotus expects them at the root of the project. See the [change](https://github.com/lotus/lotus/pull/242).

#### Lotus::Interactor

`Lotus::Interactor::Result` no longer makes available its instance variables automatically.
We need to explicitly expose them. See the [change](https://github.com/lotus/utils/pull/80).

#### Pluralized RESTful Routes

RESTful Routes have now the correct pluralization and singularization for their names. See the [change](https://github.com/lotus/router/pull/51).

## New Core Team Member

Today we're pleased to announce that [Alfonso Uceda](https://github.com/AlfonsoUceda) is joining our Core Team.

I still remember when a few months ago Alfonso confessed in chat that he never did OSS before, but he wanted to start with Lotus.
It took some time to get the first pull request accepted, but he put all his effort to reach the goal and he's now a committer.

Alfonso is the proof that you can always start contributing to Open Source.

## Rails Girls Summer of Code

One initiative that we're actively supporting to let new people to get involved with software development is [Rails Girls Summer of Code](http://railsgirlssummerofcode.org/).

It's crowdfunded program to let students to be paid for their work in Open Source.
We're a technology partner and big fans of RGSoC.

It's gonna be a thrilling summer!

## Community

We strive for an open Community, where **everyone** can feel **safe and accepted**.
We have a [Code of Conduct](/community) to handle any eventual controversy, but at the same time we're proactively leading by example.

However, **we have a problem here**: our Core Team is made of three men.

The lack of diversity worries us, and we recognize it as big problem to fix.
Lotus has still a small Community, but we want to grow it right.

We want to start a new chapter by talking with code charity organizations and individuals who are new to our industry.
We want to hear their stories, we want to listen to their problems and understand how we can help.

As last thing I want to say thank you to all the people who helped with this release: [Trung Lê](https://github.com/joneslee85), [Alfonso Uceda](https://github.com/AlfonsoUceda), [My Mai](https://github.com/mymai91), [Hiếu Nguyễn](https://github.com/hieuk09), [Ngọc Nguyễn](https://github.com/nguyenngoc2505), [Tom Kadwill](https://github.com/tomkadwill), [Arjan van der Gaag](https://github.com/avdgaag), [Jeremy Friesen](https://github.com/jeremyf), [Matthew Bellantoni](https://github.com/mjbellantoni) and [Bohdan V.](https://github.com/g3d).

## Guides

During the past months the most common request for new developers were about guides.
Lotus brings new ideas that need to be explained to people who never get exposed to it.

We want to be beginner friendly.
We wrote a new extensive [section](/guides) in our website to explain what's Lotus, what priciples it applies and [how to build the first application](/guides/getting-started).

## Conclusion

Lotus can be considered today a good choice to build web applications with Ruby.
We'll continue to deliver value and new features starting from tomorrow.

[Happy hacking](/guides/getting-started).

<div style="display: inline">

  <iframe src="https://ghbtns.com/github-btn.html?user=lotus&repo=lotus&type=star&count=true&size=large" frameborder="0" scrolling="0" width="160px" height="30px"></iframe>

  <a href="https://news.ycombinator.com/submit" class="hn-button" data-title="Announcing Lotus v0.4.0" data-url="http://lotusrb.org/blog/2015-06-23-announcing-lotus-040.html" data-count="horizontal" data-style="facebook">Vote on Hacker News</a>
  <script type="text/javascript">var HN=[];HN.factory=function(e){return function(){HN.push([e].concat(Array.prototype.slice.call(arguments,0)))};},HN.on=HN.factory("on"),HN.once=HN.factory("once"),HN.off=HN.factory("off"),HN.emit=HN.factory("emit"),HN.load=function(){var e="hn-button.js";if(document.getElementById(e))return;var t=document.createElement("script");t.id=e,t.src="//hn-button.herokuapp.com/hn-button.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(t,n)},HN.load();</script>
  <script type="text/javascript">
    reddit_url = "http://lotusrb.org/blog/2015-06-23-announcing-lotus-040.html";
  </script>
  <script type="text/javascript" src="//www.redditstatic.com/button/button1.js"></script>
</div>
