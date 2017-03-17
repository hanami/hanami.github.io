---
title: Announcing Hanami v1.0.0.beta3
date: 2017-03-17 13:37 UTC
tags: announcements
author: Marion Schleifer
image: true
excerpt: >
  Small fixes and enhancements leading up to the stable v1.0.0 version
---

## Minor Changes

`v1.0.0.beta3` is a patch release for few bug fixes and small changes:

- Action's `flash` is now public API
- Added form helpers: `time_field`, `month_field`, `week_field`, `range_field`, `search_field`, `url_field`, `tel_field`, and `image_button`
- Added HTML5 helpers for `<dialog>`, `<hgroup>`, `<rtc>`, `<slot>`, and `<var>` HTML5 tags
- Use `$stdout` instead of `STDOUT` as default stream for `Hanami::Logger`
- Disconnect from stale connections when rebooting an application in production
- Don't mount `Hanami::CommonLogger` middleware if logging is disabled for the project
- Remove `Hanami::Utils::Attributes` as no longer used
- Remove deprecated `Hanami::Utils::Json.load` and `.dump`, use `.parse` and `.generate` instead
- Remove deprecated `Hanami::Interactor::Result#failing?`, use `#failure?` instead
- Remove deprecated `Hanami::View::Rendering::LayoutScope#content`, use `#local` instead
- Remove deprecated `Hanami::Application#default_format`, use `#default_request_format` instead
- Safely boot the application if mailers aren't configured
- Ensure code reloading don't misconfigure mailer settings

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

* [Alfonso Uceda](https://github.com/AlfonsoUceda)
* [Anton Davydov](https://github.com/davydovanton)
* [Dmitriy Ivliev](https://github.com/moofkit)
* [Marcello Rocha](https://github.com/mereghost)
* [Marion Duprey](https://github.com/TiteiKo)
* [Marion Schleifer](https://github.com/marionschleifer)
* [Oana Sipos](https://github.com/oana-sipos)
* [Sean Collins](https://github.com/cllns)
* [Semyon Pupkov](https://github.com/artofhuman)
* [Tobias Sandelius](https://github.com/sandelius)

## How To Update Your Project

Edit your `Gemfile`:

```ruby
gem 'hanami', '1.0.0.beta3'
gem 'hanami-model', '1.0.0.beta3'
```

Then run `bundle update hanami hanami-model`.

## What's Next?

The final stable release (`v1.0.0`) will happen between the end of March and the beginning of April 2017, which coincides with the [Hanami season in Japan](http://www.japan-guide.com/sakura/). 🌸
