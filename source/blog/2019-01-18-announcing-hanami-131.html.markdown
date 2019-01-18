---
title: Announcing Hanami v1.3.1
date: 2019-01-18 18:26:43 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Patch release for bugfixes.
---

Hello wonderful community!

Today we're happy to announce `v1.3.1` 🙌.

## Enhancements 🆙

  * Support for Ruby 2.6
  * Support for `bundler` 2+

## Bug Fixes 🐞

  * Make optional _nested assets_ feature to maintain backward compatibility with 1.2.x
  * Remove from app generator support for deprecated `force_ssl` setting
  * Remove from app generator support for deprecated `body_parsers` setting
  * Fix `Hash` serialization for `Hanami::Utils::Logger`
  * Make app generator to work when code in `config/enviroment.rb` uses double quotes
  * Add missing `pathname` require in `lib/hanami/utils.rb`

## Released Gems 💎

  * `hanami-1.3.1`
  * `hanami-model-1.3.1`
  * `hanami-assets-1.3.1`
  * `hanami-cli-0.3.1`
  * `hanami-mailer-1.3.1`
  * `hanami-helpers-1.3.1`
  * `hanami-view-1.3.1`
  * `hamami-controller-1.3.1`
  * `hanami-router-1.3.1`
  * `hanami-validations-1.3.1`
  * `hanami-utils-1.3.1`

## How to install ⌨️

```shell
$ gem install hanami
$ hanami new bookshelf
```

## How to upgrade ⬆

```shell
$ bundle update hanami hanami-model
```

Happy coding! 🌸
