---
title: Announcing Hanami v1.2.0.rc2
date: 2018-04-06 09:36 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Minor features and bug fixes from <code>v1.2.0.rc1</code>
---

Hello people!

Today we're happy to announce `v1.2.0.rc2` release 🙌 , with the stable release (`v1.2.0`) scheduled for **April 2018**.

## Enhancements 🍰

  * Use different colors for each `Hanami::Logger` level
  * Introduce `Hanami::Action::Flash#each` and `#map`
  * Allow `submit` and `button` form helpers to accept blocks
  * Let `fields_for_collection` to iterate thru the given collection and yield current index and value

## Bug fixes 🐛

  * Ensure `select` helper to set the `selected` attribute properly when an `<option>` has a `nil` value
  * Ensure to not reload code under `lib/` when `shotgun` isn't bundled

## Released Gems 💎

  * `hanami-1.2.0.rc2`
  * `hanami-model-1.2.0.rc2`
  * `hanami-assets-1.2.0.rc2`
  * `hanami-cli-0.2.0.rc2`
  * `hanami-mailer-1.2.0.rc2`
  * `hanami-helpers-1.2.0.rc2`
  * `hanami-view-1.2.0.rc2`
  * `hamami-controller-1.2.0.rc2`
  * `hanami-router-1.2.0.rc2`
  * `hanami-validations-1.2.0.rc2`
  * `hanami-utils-1.2.0.rc2`
  * `hanami-webconsole-0.1.0.rc2`
  * `hanami-ujs-0.1.0.rc2`

## How to try it

```shell
gem install hanami --pre
hanami new bookshelf
```

## What's next?

We may release a new release candidate with bug fixes.
The stable release is expected on **April 2018**, in the meantime, please try this release candidate and report issues.

Happy coding! 🌸
