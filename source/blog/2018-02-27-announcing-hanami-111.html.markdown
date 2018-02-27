---
title: Announcing Hanami v1.1.1
date: 2018-02-27 17:18 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Patch release for bug fixes and minor enhancements
---

This is a patch release for bug fixes and minor enhancements:

  * Added support for Ruby MRI 2.5+
  * Fixed regression for mailer generator: when using options like `--from` and `--to` the generated Ruby code isn't valid as it was missing string quotes.
  * Generate tests for views including `:format` in `exposures`. This fixes view unit tests when the associated template renders a partial.
  * Ensure `exposures` are properly overwritten for partials when `locals:` option is used
  * Ensure `Hanami::Action#send_file` and `#unsafe_send_file` to run `after` action callbacks
  * Ensure Rack env to have the `REQUEST_METHOD` key set to `GET` during actions unit tests
  * Ensure `Hanami::Router` to properly respond to `unlink` HTTP requests
  * HTML helpers: print `href` and `src` first in output HTML
  * Ensure `#select` form helper to not select options with `nil` value
  * Ensure `#fields_for_collection` form helper to produce input fields with correct `name` attribute
  * Ensure `#select` form helper to respect `:selected` option
  * CLI: Ensure default values for arguments to be sent to commands
  * CLI: Ensure to fail when a missing required argument isn't provider, but an option is provided instead
  * Make `Hanami::Utils::Files.write` idempotent: ensure to truncate the file before to write
  * Don't erase file contents when invoking `Hanami::Utils::Files.touch`
  * Deprecate `Hanami::Utils::Files.rewrite` in favor of `.write`
  * Introduce `Hanami::Utils::Hash.deep_stringify` to recursively stringify a hash
  * Ensure `Hanami::Interactor#call` to accept non-keyword arguments

## Released Gems

  * `hanami-1.1.1`
  * `hanami-assets-1.1.1`
  * `hanami-cli-1.1.1`
  * `hanami-helpers-1.1.1`
  * `hanami-view-1.1.1`
  * `hanami-controller-1.1.1`
  * `hanami-router-1.1.1`
  * `hanami-utils-1.1.2`

## Contributors

We're grateful for each person who contributed to this release. These lovely people are:

  * [Alfonso Uceda](https://github.com/AlfonsoUceda)
  * [Anton Davydov](https://github.com/davydovanton)
  * [Luca Guidi](https://github.com/jodosha)
  * [Marcello Rocha](https://github.com/mereghost)
  * [Marion Duprey](https://github.com/TiteiKo)
  * [Marion Schleifer](https://github.com/marionschleifer)
  * [Oana Sipos](https://github.com/oana-sipos)
  * [Sean Collins](https://github.com/cllns)
  * [Yuta Tokitake](https://github.com/tokichie)
  * [malin-as](https://github.com/malin-as)

## How To Update Your Project

`bundle update hanami-utils hanami-router hanami-controller hanami-helpers hanami-cli hanami-assets hanami`

Happy coding! 🌸
