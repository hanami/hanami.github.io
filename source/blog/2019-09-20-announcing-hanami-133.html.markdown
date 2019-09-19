---
title: Announcing Hanami v1.3.3
date: 2019-09-20 09:18:18 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Patch release for bugfixes.
---

Hello wonderful community!

Today we're happy to announce `v1.3.3` 🙌.

## Enhancements 🆙

  * Standardize file loading for `.env` files (see: [`dotenv` documentation](https://github.com/bkeepers/dotenv#what-other-env-files-can-i-use))

## Bug Fixes 🐞

  * Ensure to use `:host` option when mounting an application in main router (e.g. `mount Beta::Application.new, at: "/", host: "beta.hanami.test"`)

## Released Gems 💎

  * `hanami-1.3.3`

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
