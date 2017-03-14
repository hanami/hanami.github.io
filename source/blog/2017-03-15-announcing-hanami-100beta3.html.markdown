---
title: Announcing Hanami v1.0.0.beta3
date: 2017-03-15 13:02 UTC
tags: announcements
author: Luca Guidi & Marion Schleifer
image: true
excerpt: >
  Small fixes and enhancements leading up to the stable 1.0.0 version
---

## Minor Changes

`v1.0.0.beta3` is a patch release for few bug fixes and small changes:

- Removing mailer config causes showstopper exception
- Ensure project to work without mailer configuration
- Don't mount `Hanami::CommonLogger` if `Hanami.logger` is nil
- Use `$stdout` instead of `STDOUT` as default stream for `Hanami::Logger`
- API docs cleanup
- Remove deprecated `Hanami::Utils::Json.load` and `.dump`
- Remove deprecated `Hanami::Interactor::Result#failing?`
- Remove `Hanami::Utils::Attributes` as no longer used
- Use `$stdout` instead of `STDOUT` as default stream for `Hanami::Logger`
- Removed `Utils::Attributes`
- Removed `Hanami::Interactor::Result#failing?`
- Removed `Utils::Json.load` and `.dump`
- Introduced `Hanami::Model.disconnect` to disconnect all the active database connections
- Fix example with confirmation in params

## Released Gems

  * `hanami-1.0.0-beta3`
  * `hanami-model-1.0.0.beta3`
  * `hanami-utils-1.0.0.beta3`
  * `hanami-validations-1.0.0.beta2`
  * `hanami-router-1.0.0.beta3`
  * `hanami-controller-1.0.0.beta3`
  * `hanami-view-1.0.0.beta2`
  * `hanami-helpers-1.0.0.beta2`
  * `hanami-mailer-1.0.0.beta2`
  * `hanami-assets-1.0.0.beta2`


## Contributors

We're grateful for each person who contributed to this release. These lovely people are:

* [Luca Guidi](https://github.com/jodosha)
* [Alfonso Uceda](https://github.com/AlfonsoUceda)
* [Anton Davydov](https://github.com/davydovanton)
* [Marcello Rocha](https://github.com/mereghost)
* [Marion Duprey](https://github.com/TiteiKo)
* [Marion Schleifer](https://github.com/marionschleifer)
* [Oana Sipos](https://github.com/oana-sipos)
* [Sean Collins](https://github.com/cllns)
* [Tobias Sandelius](https://github.com/sandelius)
* [Semyon Pupkov](https://github.com/artofhuman)

## How To Update Your Project

Edit your `Gemfile`:

```ruby
gem 'hanami', '1.0.0.beta3'
gem 'hanami-model', '1.0.0.beta3'
```

Then run `bundle update hanami hanami-model`.

## What's Next?

The final stable release (`v1.0.0`) will happen between the end of March and the beginning of April 2017, which coincides with the [Hanami season in Japan](http://www.japan-guide.com/sakura/). 🌸
