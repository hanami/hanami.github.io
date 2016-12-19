---
title: Announcing Hanami v0.9.2
date: 2016-12-19 14:54 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Patch release for small bug fixes: Pending specs, Rake tasks, SSL redirects, project boot, Rack exceptions, flash messages, form helpers, pluralizations.
---

This is a patch release for small bug fixes:

  * Mark unit tests/specs as pending for generated actions and views
  * Rake task `:environment` no longer depends on `:preload`, which was removed by v0.9.0
  * Force SSL redirects to the default port or to the configured one
  * Boot the project when is booted outside of `hanami server` (eg. `puma` or `rackup`)
  * Expose `flash` by default from actions to views
  * Don't reference exceptions in Rack env's `rack.exception`, if the exception is handled
  * Allow `#form_for` to accept entities for `:values` option
  * Respect `:precision` option in `#format_number` helper
  * Ensure `#check_box` to check/uncheck fields when a boolean value is given
  * Introduced `Hanami::Interactor::Result#failure?` and deprecate `#failing?`
  * Fix pluralization of words that end with `en`, `ens`

## Released Gems

  * `hanami-0.9.2`
  * `hanami-utils-0.9.2`
  * `hanami-controller-0.8.1`
  * `hanami-helpers-0.5.1`

## Contributors

We're grateful for each person who contributed to this release. These lovely people are:

* [The Crab](https://github.com/theCrab)
* [Paweł Świątkowski](https://github.com/katafrakt)
* [Grachev Mikhail](https://github.com/mgrachev)
* [Sean Collins](https://github.com/cllns)
* [Alex Coles](https://github.com/myabc)
* [Anton Davydov](https://github.com/davydovanton)
* [Ksenia Zalesnaya](https://github.com/ksenia-zalesnaya)
* [Marion Duprey](https://github.com/TiteiKo)
* [Thorbjørn Hermansen](https://github.com/thhermansen)
* [Marion Schleifer](https://github.com/marionschleifer)
* [Juha](https://github.com/Newman101)

## How To Update Your Project

From the root of your Hanami project: `bundle update hanami`.
