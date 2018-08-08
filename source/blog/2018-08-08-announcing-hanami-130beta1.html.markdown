---
title: Announcing Hanami v1.3.0.beta1
date: 2018-08-08 07:54:21 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Switch to RSpec, deprecations, minor enhancements, and bug fixes.
---

Hello wonderful community!

Today we're happy to announce `v1.3.0.beta1` release 🙌 , with the stable release (`v1.3.0`) scheduled for **October 2018**.

## Release 😻

The 1.3 series is a preparatory work for 2.0.

We care **a lot** about Semantic Versioning and to make the upgrade as smooth as possible for the next major release.
This is why we took the change to focus only on stability and to introduce enhancements to ease the upgrade.

## RSpec is the new default testing framework 🏆

Back in the days, when I started Hanami ([which used to be known as Lotus](/blog/2016/01/22/lotus-is-now-hanami.html)), the choice about the default testing framework fell on Minitest because it's lightweight and feels more _rubyish_ (if this is a thing). I used a lot Minitest at that time, especially for gems.

But I recognized that I rarely used it for web apps. For this kind of Ruby code, the completeness of RSpec makes my life easier.

Because Hanami is an _opinionated software_, because we want to offer what we thing it's the best experience, we decided to promote RSpec as the default testing framework.

Since now on the following command will generate a new project with RSpec:

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

Since 2.0 it won't be possible to do `Hanami::Utils::String.new("foo").underscore` anymore.
Please use the corresponding class method: `Hanami::Utils::String.underscore("foo")`.

From 2.0 these two classes will be turned into modules.

### Inflector 🔠

We deprecated `Hanami::Utils::Inflector`, `Hanami::Utils::String.pluralize`, and `.singularize`.
From future versions, Hanami will use [`dry-inflector`](http://dry-rb.org/gems/dry-inflector/).

### Body parsers 📃

We deprecated `body_parsers` as setting in Hanami apps.

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

Please the corresponding webserver (eg. Nginx) feature, a Rack middleware (eg. `rack-ssl`), or another strategy to force HTTPS connection.

### Action's parsed_body 🚫

We deprecated `Hanami::Action#parsed_body`, and it will be removed in future releases of Hanami.

## Minor Enhancements 🆙

  * Preserve directory structure of assets at the precompile time
  * Generate actions/views/mailers with nested module/class definition
  * CLI: Introduce array type for arguments (`foo exec test spec/bookshelf/entities spec/bookshelf/repositories`)
  * CLI: Introduce array type for options (`foo generate config --apps=web,api`)
  * CLI: Introduce variadic arguments (`foo run ruby:latest -- ruby -v`)

## Bug Fixes 🐞

  * Make possible to pass extra settings for custom logger instances (eg. `logger SemanticLogger.new, :foo, :bar`)
  * Ensure `hanami generate app` to work without `require_relative` entries in `config/enviroment.rb`
  * Fixed regression for `hanami new .` that used to generate a broken project
  * Don't use thread unsafe `Dir.chdir` to serve static assets
  * Ensure that if `If-None-Match` or `If-Modified-Since` response HTTP headers are missing, `Etag` or `Last-Modified` headers will be in response HTTP headers.
  * Don't show flash message for the request after a HTTP redirect.
  * Ensure `Hanami::Action::Flash#each`, `#map`, and `#empty?` to not reference stale flash data.
  * Ensure to set `:disable_escape` option only for `slim` and don't let `tilt` to emit a warning for other template engines
  * Ensure partial rendering to respect `format` overriding
  * Print informative message when unknown or wrong option is passed to CLI commands

## Released Gems 💎

  * `hanami-1.3.0.beta1`
  * `hanami-model-1.3.0.beta1`
  * `hanami-assets-1.3.0.beta1`
  * `hanami-cli-0.3.0.beta1`
  * `hanami-mailer-1.3.0.beta1`
  * `hanami-helpers-1.3.0.beta1`
  * `hanami-view-1.3.0.beta1`
  * `hamami-controller-1.3.0.beta1`
  * `hanami-router-1.3.0.beta1`
  * `hanami-validations-1.3.0.beta1`
  * `hanami-utils-1.3.0.beta1`

## How to try it ⌨️

```shell
gem install hanami --pre
hanami new bookshelf
```

## What's next? ⏰

We'll release new beta versions, with enhancements, and bug fixes.
The stable release is expected on **October 2018**, in the meantime, please try this beta and report issues.

Happy coding! 🌸
