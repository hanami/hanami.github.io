---
title: Announcing Hanami v0.7.2
date: 2016-02-09 11:46 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Fix for static assets middleware
---

This release fixes only one regression introduced by [v0.7.1](/blog/2016/02/05/announcing-hanami-071.html).

## Bug Fixes

### hanami [v0.7.2](https://github.com/hanami/hanami/blob/master/CHANGELOG.md#v072---2016-02-09)

  - Fixed routing issue when static assets server tried to hijiack paths that are matching directories in public directory [[Alfonso Uceda Pompa](https://github.com/AlfonsoUceda)]

## Upgrade Instructions

In order to get these bug fixes edit `Gemfile` to make sure it uses the right dependencies and then run `bundle update` from the root of the project.
