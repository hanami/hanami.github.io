---
title: Announcing Hanami v1.3.2
date: 2019-07-26 13:22:47 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Patch release for bugfixes.
---

Hello wonderful community!

Today we're happy to announce `v1.3.2` 🙌.

## Enhancements 🆙

  * Support for `hanami-validations` 1 & 2

## Bug Fixes 🐞

  * Ensure `hanami generate` syntax for Welcome page is compatible with ZSH
  * Don't let `hanami` executable to crash when called without `bundle exec`
  * Ensure to load i18n backend (including `i18n` gem), when validations messages engine is `:i18n`

## Released Gems 💎

  * `hanami-1.3.2`
  * `hanami-validations-1.3.4`

## How to install ⌨️

```shell
$ gem install hanami
$ hanami new bookshelf
```

## How to upgrade ⬆

```shell
$ bundle update hanami hanami-validations
```

Happy coding! 🌸
