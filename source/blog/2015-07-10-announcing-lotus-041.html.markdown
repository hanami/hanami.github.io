---
title: Announcing Lotus v0.4.1
date: 2015-07-10 17:16 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Lotus patch release: Fix container routes, Rack middleware sessions and CLI commands.
---

## Fixes

This patch release ships only with bug fixes.
Thanks to all our contributors who have reported and fixed issues.

### Container Architecture Routes

[Thiago Felippe](https://github.com/theocodes) and [Alfonso Uceda](https://github.com/AlfonsoUceda) fixed duplicated route segments for applications mounted in [Lotus Container](/guides/architectures/container).

The following configuration was generating the `/admin` prefix twice:  `/admin/admin/dashboard` instead of `/admin/dashboard`.

```ruby
Lotus::Container.configure do
  mount Admin::Application, at: `/admin`
end
```

### Database Creation for PostgreSQL

[Nick Coyne](https://github.com/nickcoyne) fixed database creation for PostgreSQL.
It now uses `createdb` when we do `lotus db create`.

### Explicit Partial Search

[Farrel Lifson](http://github.com/farrel) suggested a patch to force explicit partial finding in case of name clash.

### Apps In Console

[Alfonso Uceda](https://github.com/AlfonsoUceda) fixed application loading in `lotus console`

### Session Secret

[Alfonso Uceda](https://github.com/AlfonsoUceda) fixed generator for [application arch](/guides/architectures/application) to generate session secret

### Generators

[Alfonso Uceda](https://github.com/AlfonsoUceda), [Trung Lê](https://github.com/joneslee85), [Hiếu Nguyễn](https://github.com/hieuk09) and [Miguel Molina](https://github.com/mvader) fixed application and model generators when database name is mispelled or entity name is missing, respectively.

### Session Middleware

I fixed Rack middleware in order to makes sessions available to other Rack components.

## Roadmap For v0.5.0

A few days ago, we have [published the roadmap for v0.5.0](http://bit.ly/lotusrb-roadmap-v050), which is scheduled for **Sep 23, 2015**.
It includes **websockets**, **assets**, **mailers**, **associations** and experimental features.
Please join the discussion and let us to hear your opinion.
Thank you!

