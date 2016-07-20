---
title: Announcing Hanami v0.7.3
date: 2016-05-23 07:43 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Faster static assets in development
---

This release introduces faster static assets in development.

## Bug Fixes

### hanami [v0.7.3](https://github.com/hanami/hanami/blob/0.7.x/CHANGELOG.md#v073---2016-05-23)

  - Use `Shotgun::Static` to serve static files in development mode and avoid to reload the env [Pascal Betz](https://github.com/pascalbetz)

## Upgrade Instructions

Please edit the `Gemfile` of your project, change Hanami version into `0.7.3` and then run `bundle update hanami`.
