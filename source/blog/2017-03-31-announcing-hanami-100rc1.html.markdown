---
title: Announcing Hanami v1.0.0.rc1
date: 2017-03-31 08:21 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Small fixes and enhancements leading up to the stable v1.0.0 version
---

## Minor Changes

`v1.0.0.rc1` is a patch release for few bug fixes and small changes:

- Let `Hanami::Mailer.deliver` to bubble up `ArgumentError` exceptions
- Allow `logger` setting in `config/environment.rb` to accept arbitrary arguments to make `Hanami::Logger` to be compatible with Ruby's `Logger`. (eg. `logger 'daily', level: :info`)
- Ensure code reloading don't misconfigure mailer settings (regression from `v1.0.0.beta3`)
- Ensure database disconnection to happen in the same thread of `Hanami.boot`
- Ensure `mailer` block in `config/environment.rb` to be evaluated multiple times, according to the current Hanami environment
- Ensure a Hanami project to require only once the code under `lib/`

## Released Gems

  * `hanami-1.0.0.rc1`
  * `hanami-model-1.0.0.rc1`
  * `hanami-utils-1.0.0.rc1`
  * `hanami-validations-1.0.0.rc1`
  * `hanami-router-1.0.0.rc1`
  * `hanami-controller-1.0.0.rc1`
  * `hanami-view-1.0.0.rc1`
  * `hanami-helpers-1.0.0.rc1`
  * `hanami-mailer-1.0.0.rc1`
  * `hanami-assets-1.0.0.rc1`

## Contributors

We're grateful for each person who contributed to this release. These lovely people are:

* [Alfonso Uceda](https://github.com/AlfonsoUceda)
* [Anton Davydov](https://github.com/davydovanton)
* [Marcello Rocha](https://github.com/mereghost)
* [Marion Duprey](https://github.com/TiteiKo)
* [Marion Schleifer](https://github.com/marionschleifer)
* [Oana Sipos](https://github.com/oana-sipos)
* [Sean Collins](https://github.com/cllns)

## How To Update Your Project

Edit your `Gemfile`:

```ruby
gem 'hanami', '1.0.0.rc1'
gem 'hanami-model', '1.0.0.rc1'
```

Then run `bundle update hanami hanami-model`.

## What's Next?

The final stable release (`v1.0.0`) will happen at the beginning of April 2017, which coincides with the [Hanami season in Japan](http://www.japan-guide.com/sakura/). 🌸
