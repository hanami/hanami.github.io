---
title: Announcing Hanami v0.7.1
date: 2016-02-05 15:41 UTC
tags: announcements
author: Trung Lê
image: true
excerpt: >
  Fixes for static assets serving, Hanami console and minor improvements
---

This is a patch release that addresses some bugs reported after [v0.7.0 release](/blog/2016/01/22/lotus-is-now-hanami.html).

## Bug Fixes

### hanami [v0.7.1](https://github.com/hanami/hanami/blob/master/CHANGELOG.md#v071---2016-02-05)

  - Fix console engine fallback [[Anatolii Didukh](https://github.com/railsme)]
  - Fixed routing issue when static assets server tried to hijiack requests belonging to dynamic endpoints [[Anton Davydov](https://github.com/davydovanton)]

### hanami-utils [v0.7.1](https://github.com/hanami/utils/blob/master/CHANGELOG.md#v071---2016-02-05)

  - Allow non string objects to be escaped by `Hanami::Utils::Escape` [[Sean Collins](https://github.com/cllns)]
  - `Hanami::Utils::Escape`: fixed Ruby warning for `String#chars` with a block, which is deprecated. Using `String#each_char` now [[Yuuji Yaginuma](https://github.com/y-yagi)]

### hanami-router [v0.6.2](https://github.com/hanami/router/blob/master/CHANGELOG.md#v062---2016-02-05)

  - Fix double leading slash for Capybara's `current_path` [[Anton Davydov](https://github.com/davydovanton)]

### hanami-controller [v0.6.1](https://github.com/hanami/controller/blob/master/CHANGELOG.md#v061---2016-02-05)

  - Optimise memory usage by freezing MIME types constant [[Anatolii Didukh](https://github.com/railsme)]

### hanami-view [v0.6.1](https://github.com/hanami/view/blob/master/CHANGELOG.md#v061---2016-02-05)

  - Preload partial templates in order to boost performances for partials rendering (2x faster) [[Steve Hook](https://github.com/stevehook)]

### hanami-model [v0.6.2](https://github.com/hanami/model/blob/master/CHANGELOG.md#v062---2016-02-05)

  - Mapping SQL Adapter's errors as `Hanami::Model` errors [[Hélio Costa e Silva](https://github.com/hlegius)] &amp; [[Pascal Betz](https://github.com/pascalbetz)]

### hanami-assets [v0.2.1](https://github.com/hanami/assets/blob/master/CHANGELOG.md#v021---2016-02-05)

  - Fix recursive Sass imports [[Luca Guidi](https://github.com/jodosha)]
  - Ensure to truncate assets in `public/` before to precompile/copy them [[Luca Guidi](https://github.com/jodosha)]

## Upgrade Instructions

In order to get these bug fixes edit `Gemfile` to make sure it uses the right dependencies and then run `bundle update` from the root of the project.
