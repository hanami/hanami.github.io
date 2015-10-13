---
title: Announcing Lotus v0.5.0
date: 2015-09-30 07:11 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Features: Mailers, custom data mapper coercions, command / query separation.
  Rails Girls Summer of Code and Hack Day!
---

This new Lotus release is an important step towards 1.0!

In the past months we talked with people at conferences, meetups, events, you all are eagerly looking for a **production ready version**.
This makes us proud of Lotus and we are determined to get there.

That's why we have decided to **postpone** a few announced features like WebSocket and experimental code reloading.

## Features

Let's have a look at what is shipped with this version.

### Mailers

Inês & Rosa (aka [DEIGirls](https://twitter.com/teamdeigirls)), are the [Rails Girls Summer of Code](http://railsgirlssummerofcode.org) students who worked on mailers.
During these three months, mentored by [Trung Lê](https://github.com/joneslee85), they learned about Ruby, Lotus and they shipped their first gem: `lotus-mailer`.
This is a huge achievement for all of us!

We have introduced a generator, which creates a mailer, the test code and two associated templates for multipart delivery.

```shell
% bundle exec lotus generate mailer forgot_password
      create  spec/bookshelf/mailers/forgot_password_spec.rb
      create  lib/bookshelf/mailers/forgot_password.rb
      create  lib/bookshelf/mailers/templates/forgot_password.txt.erb
      create  lib/bookshelf/mailers/templates/forgot_password.html.erb
```

For simplicity, each mailer can handle **only one use case (feature)**.
If in our application we need to send emails for several features like: _"confirm your email address"_ or _"forgot password"_, we will have `Mailers::ConfirmEmailAddress` and `Mailers::ForgotPassword` **instead** of a generic `UserMailer` that manages all these use cases.

```ruby
# lib/bookshelf/mailers/forgot_password.rb
class Mailers::ForgotPassword
  include Lotus::Mailer

  from    'noreply@lotusrb.org'
  to      'user@example.com'
  subject 'Hello'
end

# Usage
Mailers::ForgotPassword.deliver
```
[Lotus::Mailer](https://github.com/lotus/mailer) is built on top of the rock solid `mail` [gem](https://github.com/mikel/mail) by Mikel Lindsaar.

[Read the guides](/guides/mailers/overview)

### Custom Data Mapper Coercions

Lotus data mapper supports the most common Ruby data type such as `String`, `Integer`, or `DateTime`.
Sometimes, this simple approach is not enough to solve the database impedance mismatch on types.

Imagine we have a `Book#tags`, a collection of strings that we want to store as a [Postgres array](http://www.postgresql.org/docs/9.1/static/arrays.html).
If we use `Array` builtin type, our tags aren't properly translated into a format that is compatible with our column type.

The solution to this problem is to define a custom coercer.

```ruby
# lib/ext/pg_array.rb
require 'lotus/model/coercer'
require 'sequel/extensions/pg_array'

class PGArray < Lotus::Model::Coercer
  def self.dump(value)
    ::Sequel.pg_array(value, :varchar)
  end

  def self.load(value)
    ::Kernel.Array(value) unless value.nil?
  end
end
```

```ruby
# lib/bookshelf.rb
require_relative './ext/pg_array'
# ...

Lotus::Model.configure do
  # ...
  mapping do
    # ...
    collection :articles do
      attribute :id,   Integer
      attribute :tags, PGArray
    end
  end
end.load!
```

[Read the guides](/guides/models/overview)

### Command / Query Separation

When the powerful repositories API doesn't fit our needs, we can send raw command and queries to the database.
Until now there was a generic `.execute` to use. Both the signature and the semantic of this method, became too complex, so we decided to add `.fetch`.

It returns a **raw dataset** from the database.

```ruby
# lib/bookshelf/repositories/book_repository.rb
class BookRepository
  include Lotus::Repository

  def self.raw_all
    fetch("SELECT * FROM books")
  end

  def self.find_all_titles
    fetch("SELECT title FROM books").map do |book|
      book[:title]
    end
  end
end
```

We changed `.execute` send a raw command and return `nil`.

```ruby
# lib/bookshelf/repositories/book_repository.rb
class BookRepository
  include Lotus::Repository

  def self.reset_download_count
    execute("UPDATE books SET download_count = 0")
  end
end
```

[Read the guides](/guides/models/repositories)

### Minor Changes

Thanks to [Theo Felippe](https://github.com/theocodes) for the MIME type detection work and to [Wellington Santos](https://github.com/manuwell) for a better exception handling.
To [Pascal Betz](https://github.com/pascalbetz), [José Mota](https://github.com/josemota), [Alex Wochna](https://github.com/awochna) and [Khải Lê](https://github.com/khaiql) for their form helper enhancements, while [Leonardo Saraiva](https://github.com/vyper) wrote an expanded version of `#link_to`.

[Alfonso Uceda](https://github.com/AlfonsoUceda) added SQL joins, [Bohdan V.](https://github.com/g3d) and [Manuel Corrales](https://github.com/ziggurat) fixed small Lotus::Model issues, while [Brenno Costa](https://github.com/brennovich) worked on JRuby support!

We're thankful for the improvements and fixes that [Ben Lovell](https://github.com/benlovell), [Rodrigo Panachi](https://github.com/rpanachi), [Derk-Jan Karrenbeld](https://github.com/SleeplessByte), [Cẩm Huỳnh](https://github.com/huynhquancam) and [Andrii Ponomarov](https://github.com/andrii) did on `lotusrb`.

### Deprecations

#### Default Format

We deprecated `default_format` in favor of `default_request_format`.

We also introduced `default_response_format` to force a MIME Type, without the need of specify it for each action.
It defaults to `:html`, but if you are building a JSON API, you may find useful to set it to `:json`.

```ruby
# apps/web/application.rb
# ...
module Web
  class Application < Lotus::Application
    configure do
      # If you are using this:
      default_format :xml

      # Please rename into:
      default_request_format :xml
    end
  end
end
```

## Hack Day

Did you always wanted to play with Lotus but you keep saying: _"I don't have time"_?

As Lotus will approach to 1.0, we'll need your help, your feedback.. and your fun! So, here's the deal.. we're organizing a Hack Day later this year!

⬇️ If you want to get alerted, please consider to subscribe to our [mailing list](http://lotusrb.org/mailing-list/) using the form below. ⬇️

**Until then, happy hacking!**

<div style="display: inline">

  <iframe src="https://ghbtns.com/github-btn.html?user=lotus&repo=lotus&type=star&count=true&size=large" frameborder="0" scrolling="0" width="160px" height="30px"></iframe>

  <a href="https://news.ycombinator.com/submit" class="hn-button" data-title="Announcing Lotus v0.5.0" data-url="http://lotusrb.org/blog/2015/09/30/announcing-lotus-050.html" data-count="horizontal" data-style="facebook">Vote on Hacker News</a>
  <script type="text/javascript">var HN=[];HN.factory=function(e){return function(){HN.push([e].concat(Array.prototype.slice.call(arguments,0)))};},HN.on=HN.factory("on"),HN.once=HN.factory("once"),HN.off=HN.factory("off"),HN.emit=HN.factory("emit"),HN.load=function(){var e="hn-button.js";if(document.getElementById(e))return;var t=document.createElement("script");t.id=e,t.src="//hn-button.herokuapp.com/hn-button.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(t,n)},HN.load();</script>
  <script type="text/javascript">
    reddit_url = "http://lotusrb.org/blog/2015/09/30/announcing-lotus-050.html";
  </script>
  <script type="text/javascript" src="//www.redditstatic.com/button/button1.js"></script>
</div>
