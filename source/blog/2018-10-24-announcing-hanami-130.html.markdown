---
title: Announcing Hanami v1.3.0
date: 2018-10-24 07:23:18 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Switch to RSpec, deprecations, minor enhancements, and bug fixes. New Guides website.
---

Hello wonderful community!

Today we're happy to announce `v1.3.0` **stable release** 🙌.

## Release 😻

The 1.3 series is a preparatory work for 2.0.

We care **a lot** about Semantic Versioning and to make the upgrade as smooth as possible for the next major release.
This is why we took the change to focus only on stability and to introduce enhancements to ease the upgrade.

## RSpec is the new default testing framework 🏆

Back in the days, when I started Hanami ([which used to be known as Lotus](/blog/2016/01/22/lotus-is-now-hanami.html)), the choice about the default testing framework fell on Minitest because it's lightweight and feels more _rubyish_ (if this is a thing). I used a lot Minitest at that time, especially for gems.

But I recognized that I rarely used it for web apps. For this kind of Ruby code, the completeness of RSpec makes my life easier.

Because Hanami is an _opinionated software_, because we want to offer what we think is the best experience, we decided to promote RSpec as the default testing framework.

From now on, the following command will generate a new project with RSpec:

```shell
$ hanami new bookshelf
```

For those who want to use Minitest:

```shell
$ hanami new bookshelf --test=minitest
```

## Deprecations 🙀

### Types 📦

We deprecated `Hanami::Utils::String` and `Hanami::Utils::Hash` as Ruby objects to be instantiated.

From 2.0 onward it won't be possible to do `Hanami::Utils::String.new("foo").underscore` anymore.
Please use the corresponding class method: `Hanami::Utils::String.underscore("foo")`.

From 2.0 these two classes will be turned into modules.

### Inflector 🔠

We deprecated `Hanami::Utils::Inflector`, `Hanami::Utils::String.pluralize`, and `.singularize`.
From future versions, Hanami will use [`dry-inflector`](http://dry-rb.org/gems/dry-inflector/).

### Body parsers 📃

We deprecated `body_parsers` as a setting in Hanami apps.

```ruby
# apps/web/application.rb
module Web
  class Application < Hanami::Application
    configure do
      # ...
      body_parsers :json
    end
  end
end
```

Please use the new middleware:

```ruby
# config/environment.rb
require "hanami/middleware/body_parser"

Hanami.configure do
  # ...
  middleware.use Hanami::Middleware::BodyParser, :json
end
```

### Force SSL 💪

We deprecated `force_ssl` as setting in Hanami apps.

```ruby
# apps/web/application.rb
module Web
  class Application < Hanami::Application
    configure do
      # ...
      force_ssl true
    end
  end
end
```

Please use the corresponding webserver (eg. Nginx) feature, a Rack middleware (eg. `rack-ssl-enforcer`), or another strategy to force HTTPS connection.

### Action's parsed_request_body 🚫

We deprecated `Hanami::Action#parsed_request_body`, and it will be removed in future releases of Hanami.

## Minor Enhancements 🆙

  * Automatically log body payload from body parsers (only in `Hanami::Middleware::BodyParser`)
  * Preserve directory structure of assets at the precompile time
  * Generate actions/views/mailers with nested module/class definition
  * CLI: Introduce array type for arguments (`foo exec test spec/bookshelf/entities spec/bookshelf/repositories`)
  * CLI: Introduce array type for options (`foo generate config --apps=web,api`)
  * CLI: Introduce variadic arguments (`foo run ruby:latest -- ruby -v`)
  * Swappable JSON backend for `Hanami::Action::Flash` based on `Hanami::Utils::Json`
  * Added `Hanami::Mailer.reply_to`
  * Added `Hanami::Utils::Files.inject_line_before_last` and `.inject_line_after_last`

## Bug Fixes 🐞

  * Make possible to pass extra settings for custom logger instances (eg. `logger SemanticLogger.new, :foo, :bar`)
  * Ensure `hanami generate app` to work without `require_relative` entries in `config/enviroment.rb`
  * Fixed regression for `hanami new .` that used to generate a broken project
  * Don't use thread unsafe `Dir.chdir` to serve static assets
  * Generate correct syntax for layout unit tests
  * Fix concatenation of `Pathname` and `String` in `Hanami::CommonLogger`
  * Ensure that if `If-None-Match` or `If-Modified-Since` response HTTP headers are missing, `Etag` or `Last-Modified` headers will be in response HTTP headers.
  * Don't show flash message for the request after a HTTP redirect.
  * Ensure `Hanami::Action::Flash#each`, `#map`, and `#empty?` to not reference stale flash data.
  * Ensure to set `:disable_escape` option only for `slim` and don't let `tilt` to emit a warning for other template engines
  * Ensure partial rendering to respect `format` overriding
  * Print informative message when unknown or wrong option is passed to CLI commands
  * Skip attempting to parse unknown MIME types (only in `Hanami::Middleware::BodyParser`)
  * Reliably parse query params for `Hanami::Model` URL connection string
  * Print meaningful error message when `Hanami::Model` URL connection is misconfigured

## Released Gems 💎

  * `hanami-1.3.0`
  * `hanami-model-1.3.0`
  * `hanami-assets-1.3.0`
  * `hanami-cli-0.3.0`
  * `hanami-mailer-1.3.0`
  * `hanami-helpers-1.3.0`
  * `hanami-view-1.3.0`
  * `hamami-controller-1.3.0`
  * `hanami-router-1.3.0`
  * `hanami-validations-1.3.0`
  * `hanami-utils-1.3.0`

## How to install it ⌨️

```shell
gem install hanami
hanami new bookshelf
```

If you're upgrading, please read the [related Guides article](https://guides.hanamirb.org/upgrade-notes/v130/).

## New Guides website 📖

We reworked the Guides website, which is now available at [https://guides.hanamirb.org](https://guides.hanamirb.org).
It now has a cleaner design and can be [downloaded](https://github.com/hanami/guides/releases) for offline consultation.

## New team member 👱

[Kai Kuchenbecker](https://twitter.com/kaikuchn) joined our core team!
If you ever asked a quesion in our [chat](http://chat.hanamirb.org) it's very likely you have been answered by him.
Kai will continue to help people in chat and to ease the process from question to solution or bugfix.

## What's next? ⏰

This release will be the last minor version of `1.x` series.
You may see patch versions to be released for bug fixes or deprecations.

**From now on, our focus will be for 2.0!**

We'll deeply integrate Hanami, [ROM](https://rom-rb.org/), & [DRY](https://dry-rb.org/). ❤️
If you're interested, keep an eye on the `unstable` branches of our [GitHub repositories](https://github.com/hanami).

Happy coding! 🌸
