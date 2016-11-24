---
title: Announcing Lotus v0.6.0
date: 2016-01-12 12:57 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Features: Assets, custom initializers, default Rake tasks, and destroy command.
---

This new release makes Lotus a complete web framework for Ruby.
It ships with the last important set of features that we planned: assets.

**We have now everything we need to build web applications with Lotus.**

## Features

### Assets

As of Lotus v0.6.0, we now have a full set of features for assets management, such as:

  * [Helpers](/guides/helpers/assets)
  * [Preprocessors](/guides/assets/preprocessors) ([Sass](http://sass-lang.com), [Less](http://lesscss.org), [ES6](http://es6-features.org), [JSX](https://jsx.github.io), [CoffeeScript](http://coffeescript.org), [Opal](http://opalrb.org), etc..)
  * [Compressors](/guides/assets/compressors) ([YUI](http://yui.github.io/yuicompressor), [UglifyJS2](http://lisperator.net/uglifyjs), [Google Closure Compiler](https://developers.google.com/closure/compiler), [Sass](http://sass-lang.com), etc..)
  * [Deployment](/guides/command-line/assets) (precompile, compress, checksum)
  * [Content Delivery Network](/guides/assets/content-delivery-network)
  * [Heroku support](/blog/2015-12-29-introducing-assets.html)
  * [Third Party Gems](/guides/assets/overview) (eg. `bootstrap` gem will support soon Lotus out of the box)
  * A new [Rack middleware](/guides/assets/overview) to serve static assets
  * Lazy precompilation + cache in development mode

Thanks to [Leigh Halliday](https://github.com/leighhalliday), [Gonzalo Rodríguez-Baltanás Díaz](https://github.com/Nerian), [deepj](https://github.com/deepj), [Michael Deol](https://github.com/michaeldeol), [Benjamin Klotz](https://github.com/tak1n), [Kleber Correia](https://github.com/klebervirgilio) for their contributions and help.

[Read the [guides](/guides/assets/overview) and the [announcement](/blog/2015-12-29-introducing-assets.html)]

### Custom Initializers

For each application under `apps/`, now we can **optionally** have a special directory (eg. `apps/web/config/initializers`) where to put Ruby source files to initialize that specific application.
Starting from `v0.6.0`, new projects and applications will be generated with that directory.

Thanks to [Lucas Allan](https://github.com/lucasallan) for this new feature.

[Read the [guides](/guides/projects/initializers)]

### Default Rake Tasks

Lotus projects now ship with two default Rake tasks: `:preload` and `:environment`.
The first is a lightweight way to load **only** the configurations of a project, while the latter loads the entire application.
We can use them as requirement for our Rake tasks:

```ruby
# Rakefile
# ...

task print_info: :preload do
  puts ENV['LOTUS_ENV']
  puts defined?(UserRepository)
end

task clear_users: :environment do
  UserRepository.clear
end
```

We can invoke these new taks with:

```shell
bundle exec rake print_info
# => "development"
# => nil
```

```shell
bundle exec rake clear_users
```

[Read the [guides](/guides/projects/rake)]

### Destroy Command

We have introduced a new CLI command `lotus destroy`.
It has the role of destroy applications (`apps/`), actions, entities, repositories, migrations, mailers and their related testing code.

```shell
bundle exec lotus destroy action web home#index
```

Thanks to [Tadeu Valentt](https://github.com/t4deu) and [Lucas Allan](https://github.com/lucasallan) for this feature.

## Minor Changes &amp; Improvements

Pluralizations can be [customized](https://github.com/lotus/utils/pull/90) by adding exceptions to default inflections.

Action generator is now [smarter](https://github.com/lotus/lotus/pull/414) and it can generate a route with the right HTTP verb, according to our REST conventions. Thanks to [Sean Collins](https://github.com/cllns).

Special thanks goes to [Tadeu Valentt](https://github.com/t4deu), [Pascal Betz](https://github.com/pascalbetz), [Andrey Deryabin](https://github.com/aderyabin), [Anton Davydov](https://github.com/davydovanton), [Caius Durling](https://github.com/caius), [Jason Charnes](https://github.com/jasoncharnes), [Sean Collins](https://github.com/cllns), and [Ken Gullaksen](https://github.com/kenglxn) for their work to make our CLI stronger than ever.

Thanks to [Neil Matatall](https://github.com/oreoshake) to prevent timing attacks for CSRF tokens comparision, [David Strauß](https://github.com/stravid) for making body parsing compatible with JSON API, [Karim Tarek](https://github.com/karimmtarek) and [Liam Dawson](https://github.com/liamdawson) for exception normalization across all our gems, [Vladislav Zarakovsky](https://github.com/vlazar) for making Force SSL compliant with Rack SPEC, while [Bernardo Farah](https://github.com/berfarah) fixed chunked responses, to [Karim Kiatlottiavi](https://github.com/constXife) for fixing HTML escape encoding, to [Rodrigo Panachi](https://github.com/rpanachi) for fixing CSRF form, to [Hélio Costa](https://github.com/hlegius) and [Pascal Betz](https://github.com/pascalbetz) for fixing how validations treat blank strings, to [Cẩm Huỳnh](https://github.com/huynhquancam) for making `#html` helper to accept blocks.

We're thankful for the help that [Hiếu Nguyễn](https://github.com/hieuk09), [Taylor Finnell](https://github.com/taylorfinnell), [Andrey Deryabin](https://github.com/aderyabin), [Cainã Costa](https://github.com/cfcosta), [Shin-ichi Ueda](https://github.com/skyriser), [Martin Rubi](https://github.com/cabeza-de-termo) offered for other minor improvement and fixes.

## Deprecations

### Ruby 2.0 &amp; 2.1

Ruby 2.0 and 2.1 are now deprecated.
We took this decision because MRI 2.0 will reach End Of Life (EOL) next month and because keeping 2.1 around would mean to leave our internals complex because of _"safe indifferent access"_.

Prior to MRI 2.2, `Symbol` instances weren't garbage collected.
This has caused security problems for Ruby applications.
If not properly filtered, untrusted input could've been lead to attacks where the server memory is entirely consumed by Ruby VM due to `Symbol` abuse.

To prevent this kind of attack, we always used strings for incoming HTTP parameters.
At the same time, we wanted to offer convenient access to these params via symbols (eg `params[:id]`).
To make this possible we had to carefully filter and convert data over and over.

By dropping 2.1, we can simplify our internal code because we don't have to worry about GC and symbols security threats.
At the same time we can provide minor perf improvements due to the lack of these conversions.

## Breaking Changes

There are several breaking changes due to assets features.

**If you're upgrading from an earlier version, please make sure to read the detailed [upgrade guide](/guides/upgrade-notes/v060) that we prepared.**
It will take a few minutes to get up and running again.

## What's Next?

Our focus for the next release (`v0.7.0`) will be about `Lotus::Model` and `Lotus::Validations`.
We want to make **stronger** and **flexible** the way we validate and persist data.

We recognized it's **too verbose** to always require **database mapping** even if it can be avoided (eg with SQL databases).
It's **not necessary** to instantiate an entity to write a record, repositories can **directly accept data** and persist it.

We want to **simplify** our day to day life with Lotus.
