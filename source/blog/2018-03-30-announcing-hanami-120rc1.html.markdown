---
title: Announcing Hanami v1.2.0.rc1
date: 2018-03-30 11:04 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Minor features and bug fixes from <code>v1.2.0.beta2</code>
---

Hello people!

Today we're happy to announce `v1.2.0.rc1` release 🙌 , with the stable release (`v1.2.0`) scheduled for **April 2018**.

## Features 🍎

  * Colored logging

## Enhancements 🍰

  * Generate non-RESTful actions with `/:controller/:action` route URL (eg. `hanami g web action books#on_sale` will correspond to `GET /books/on_sale`)

## Bug fixes 🐛

  * Generate new projects with `Gemfile` including `gem "shotgun", platforms: :ruby` in order to not install `shotgun` on Windows
  * Make `Hanami::Logger` to properly log hash messages
  * Ensure `select` helper to set the `selected` attribute properly when an `<option>` has a `nil` value
  * Ensure repository relations to access database attributes via `#[]` (eg. `projects[:name].ilike("Hanami")`)

## Released Gems 💎

  * `hanami-1.2.0.rc1`
  * `hanami-model-1.2.0.rc1`
  * `hanami-assets-1.2.0.rc1`
  * `hanami-cli-0.2.0.rc1`
  * `hanami-mailer-1.2.0.rc1`
  * `hanami-helpers-1.2.0.rc1`
  * `hanami-view-1.2.0.rc1`
  * `hamami-controller-1.2.0.rc1`
  * `hanami-router-1.2.0.rc1`
  * `hanami-validations-1.2.0.rc1`
  * `hanami-utils-1.2.0.rc1`
  * `hanami-webconsole-0.1.0.rc1`
  * `hanami-ujs-0.1.0.rc1`

## How to try it

```shell
gem install hanami --pre
hanami new bookshelf
```

## What's next?

We may release a new release candidate with bug fixes.
The stable release is expected on **April 2018**, in the meantime, please try this release candidate and report issues.

Happy coding! 🌸
