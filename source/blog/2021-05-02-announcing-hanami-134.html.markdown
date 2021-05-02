---
title: Announcing Hanami v1.3.4
date: 2021-05-02 17:04:46 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Patch release for bugfixes.
---

Hello wonderful community!

Today we're happy to announce `v1.3.4` 🙌.

## Bug Fixes 🐞

  * Fix generated `config.ru` `require_relative` statement
  * Fix `Hanami::CommonLogger` elapsed time compatibility with `rack` 2.1.0+
  * Fix generated tests compatibility with `minitest` 6.0+

## Released Gems 💎

  * `hanami-1.3.4`

## How to install ⌨️

```shell
$ gem install hanami
$ hanami new bookshelf
```

## How to upgrade ⬆

```shell
$ bundle update hanami
```

Happy coding! 🌸
