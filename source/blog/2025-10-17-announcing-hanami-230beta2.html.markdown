---
title: Announcing Hanami 2.3 beta2
date: 2025-10-17 09:30:00 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  Improved action formats, hanami run command and more.
---

Two weeks after [beta1](/blog/2025/10/03/announcing-hanami-230beta2/), it’s time for 2.3 beta2!

This will be our last beta, and we’re aiming for the full 2.3 release in two weeks. Read on to see what’s new.

## `hanami run` command

You can now can run your own scripts and code snippets with the `hanami run` command!

```shell
$ bundle exec hanami run my_script.rb
$ bundle exec hanami run 'Hanami.app["repos.commit_repo"].all.count'
```

## Improved action formats config

Our [previous approach](https://guides.hanamirb.org/v2.2/actions/formats-and-mime-types/) to action formats config (`config.formats` in action classes or `config.actions.formats` in app or slice classes) made it too hard to configure and use your own custom formats. We’ve now overhauled this config and made it much more flexible.

This is an important change and we’d love your help with testing. If you configure formats for your actions, please pull down this beta and give this a go!

**Use `config.formats.register` to register a new format and its media types.**

This replaces `config.formats.add`. Unlike `.add`, it does _not_ activate the format as “accepted” at the same time. This makes it easier to `register` your custom formats in app config or a base action class, while maintaining control over where you apply your format restrictions.

A simple registration looks like this:

```ruby
config.formats.register(:json, "application/json")
```

`.register` also allows you to register one or more media types for the different stages of request processing:

- Provide `accept_types:` to accept requests based on specific `Accept` types in request headers.
- Provide `content_types:` to accept requests based on specific `Content-Type` request headers.
- Both the above are are optional. If you do not provide these, then the format’s _default_ media type (the required second argument) is used for each.
- This default media type is also set as the default `Content-Type` response header when requests match that format.

Together, these allow you to register a format like this:

```ruby
config.formats.register(
  :jsonapi,
  "application/vnd.api+json",
  accept_types: ["application/vnd.api+json", "application/json"],
  content_types: ["application/vnd.api+json", "application/json"],
)
```

**Use `config.formats.accept` to accept specific formats from an action.**

`formats.accept` replaces `Action.format` and `config.format`. You can access your accepted formats via `formats.accepted`, which replaces `config.formats.values`.

To accept a format:

```ruby
config.formats.accept :html, :json
config.formats.accepted # => [:html, :json]

config.formats.accept :csv # Accepted formats are additive
config.formats.accepted # => [:html, :json, :csv]
```

The first format you give to `accept` will also become the _default format_ for responses from your action, but _only_ if you haven’t already configured a default using the approach below.

**Use config.formats.default=` to set an action's default format.**

This is a new capability. Assign an action’s default format using `config.formats.default=`.

The default format is used to set the response `Content-Type` header when the request does not specify a format via `Accept`.

```ruby
config.formats.accept :html, :json

# When no default is already set, the first accepted format becomes default
config.formats.default # => :html

# But you can now configure this directly
config.formats.default = :json
```

**Previous format config methods are deprecated.**

The previous format config methods (`Action.format`, `config.format`, `config.formats.add`, `config.formats.values`, and `config.formats.values=`) continue to work, but are now deprecated and will be removed in Hanami 2.4.

Switching to the methods above should be straightforward, and they give you significantly more flexibility. We hope you give them a go!

## Thank you to our patrons 🌸

Thank you to our [Hanami patrons](https://sponsor.hanamirb.org) who made this release possible! That’s [**Sidekiq**](https://sidekiq.org), [**Brandon Weaver**](https://github.com/baweaver), [**Honeybadger**](https://www.honeybadger.io/?utm_source=hanami&utm_medium=paid-referral&utm_campaign=founding-patron), [**FastRuby.io**](https://www.fastruby.io/) and [**AppSignal**](https://www.appsignal.com/).

Thank you also to all the community members supporting Hanami through our [GitHub Sponsors](https://github.com/sponsors/hanami). There are now more than 20 of you!

We’d love for you to become a patron too. [Learn more here.](https://sponsor.hanamirb.org)

## Improvements & fixes

We’ve got even more improvements and fixes in this release:

- The router sees a big runtime performance boost for large numbers of routes, addressing a performance regression that was introduced as part of some fixes in Hanami 2.2.
- `hanami generate action` now accepts a `--skip-tests` flag.
- `hanami generate action` will add routes to slice-specific `config/routes.rb` files, if present.
- `hanami generate` commands now graceully handle names given with mixed cases.
- In new apps, the `Types` module now uses `Dry.Types(default: :strict)`.
- In new apps, the generated `Guardfile` now passes the environment from `ENV["HANAMI_ENV"]`.
- The view context no longer includes `"settings"` as a default dependency. You can include this yourself if you need it.
- Errors for missing actions in routes now show friendlier, relative file paths.

With this release, we’ve also dropped support for Ruby 3.1. Hanami 2.3 will require Ruby 3.2 or later.

## We need your help!

We need your help with testing! In addition to the new action formats config, we’re still keen for feedback from people navigating the upgrade to Rack 3, which we enabled [as part of beta1](/blog/2025/10/03/announcing-hanami-230beta1/).

If you have a Hanami app, please try upgrading to 2.3.0.beta2, adopting Rack 3, and improving your action formats. We’d love to hear how you go!

## How can I try it?

```
> gem install hanami --pre
> hanami new my_app
> cd my_app
> bundle exec hanami dev
```

## What’s included?

Today we’re releasing the following:

- hanami v2.3.0.beta2
- hanami-assets v2.3.0-beta.2 (npm package)
- hanami-assets v2.3.0.beta2
- hanami-cli v2.3.0.beta2
- hanami-controller v2.3.0.beta2
- hanami-db v2.3.0.beta2
- hanami-reloader v2.3.0.beta2
- hanami-router v2.3.0.beta2
- hanami-rspec v2.3.0.beta2
- hanami-utils v2.3.0.beta2
- hanami-validations v2.3.0.beta2
- hanami-view v2.3.0.beta2
- hanami-webconsole v2.3.0.beta2

For the full list of changes, please see each package’s own CHANGELOG.

## What’s next?

We have a short list of remaining fixes and improvements to make before our proper 2.3 release. See [this GitHub project](https://github.com/orgs/hanami/projects/12/views/1) for details.

We expect to be back with 2.3 in a couple of weeks.

## Thank you to our contributors!

Thank you to all these amazing people who contributed to this release!

- [Andrea Fomera](https://github.com/afomera)
- [Brandon Weaver](https://github.com/baweaver)
- [Kyle Plump](https://github.com/kyleplump)
- [Mina Slater](https://github.com/minaslater)
- [Sean Collins](https://github.com/cllns)
- [stephannv](https://github.com/stephannv)
- [Tim Riley](https://github.com/timriley)

And thank you again for giving this beta a try! We’re looking forward to hearing your feedback. 🌸
