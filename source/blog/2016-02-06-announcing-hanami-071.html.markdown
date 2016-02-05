---
title: Announcing Hanami v0.7.1
date: 2016-02-06 15:41 UTC
tags: announcements
author: Trung Lê
image: true
excerpt: >
  Fixes for static assets URL and minor improvements
---

This is a patch release that addresses some bugs reported after [v0.7.0 release](/blog/2016/01/22/lotus-is-now-hanami.html).

## Bug Fixes

### hanamirb [v0.7.1](https://github.com/hanami/hanami/blob/master/CHANGELOG.md#v071---2016-02-06)

  - Fix console engine fallback [[Anatolii Didukh](https://github.com/railsme)]
  - Fix routing issue with static assets serving [[Anton Davydov](https://github.com/davydovanton)]

### hanami-utils [v0.7.1](https://github.com/hanami/utils/blob/master/CHANGELOG.md#v071---2016-02-06)

  - Allow non string objects to be escaped by `Hanami::Utils::Escape` [[Sean Collins](https://github.com/cllns)]
  - `Hanami::Utils::Escape`: fixed Ruby warning for `String#chars` with a block, which is deprecated. Using `String#each_char` now [[Yuuji Yaginuma](https://github.com/y-yagi)]

### hanami-router [v0.6.2](https://github.com/hanami/router/blob/master/CHANGELOG.md#v062---2016-02-06)

  - Remove entries that match seperator for path_info [[Anton Davydov](https://github.com/davydovanton)]

### hanami-controller [v0.6.1](https://github.com/hanami/controller/blob/master/CHANGELOG.md#v061---2016-02-06)

  - Optimise memory usage by freezing MIME types constant [[Anatolii Didukh](https://github.com/railsme)]

### hanami-model [v0.6.2](https://github.com/hanami/model/blob/master/CHANGELOG.md#v062---2016-02-06)

  - Mapping SQL Adapter's Errors into Hanami Model Errors [[Hélio Costa e Silva](https://github.com/hlegius)] &amp; [[Pascal Betz](https://github.com/pascalbetz)]

### hanami-assets [v0.2.1](https://github.com/hanami/assets/blob/master/CHANGELOG.md#v021---2016-02-06)

  - Ensure to truncate copied assets [[Luca Guidi](https://github.com/jodosha)]

## Upgrade Instructions

In order to get these bug fixes, just run `bundle update` from the root of the project.
