---
title: Announcing Hanami v1.3.5
date: 2021-10-18 10:03:14 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Patch release for bugfixes. New default serializer (JSON) for HTTP session Cookies storage.
---

Hello wonderful community!

Today we're happy to announce `v1.3.5` 🙌.

## Changed ⏩

  * Use JSON as default HTTP session serializer for cookie session storage

## Bug Fixes 🐞

  * Ensure to properly store exceptions in Rack environment
  * Explicitly limit in gemspec the supported rubies (>= 2.3 and < 3) for Hanami 1k
  * Ensure `.validations` to not raise `NoMethodError: undefined method 'size' for nil:NilClass`. Due to a breaking change in transitive dependency (`dry-configurable` `0.13.x`).

## Released Gems 💎

  * `hanami` `v1.3.5`
  * `hanami-validations` `v1.3.8`

## How to install ⌨️

```shell
$ gem install hanami
$ hanami new bookshelf
```

## How to upgrade ⬆

```shell
$ bundle update hanami
```

⚠️ **If you're using HTTP sessions with cookies (default), please note that we changed the default session serializer from `Rack::Session::Cookie::Base64::Marshal` (Rack default) to `Rack::Session::Cookie::Base64::JSON`.**⚠️ 

We received a security disclosure that proves that `Marshal` based serialization is vulnerable to an attack.
To know more, please read the discussion over [GitHub](https://github.com/hanami/hanami/pull/1127).

To **upgrade** your application:

1. Update `hanami` version (`bundle update hanami`)
2. Rotate the session secret in production (usually `WEB_SESSIONS_SECRET` in `.env`). This will cause an expiration of current HTTP sessions. This is needed because you're going to change the low level (de)serialization mechanism of HTTP sessions.
3. Deploy the app

Special thanks go to ooooooo_q and [Maciej Mensfeld](https://github.com/mensfeld) for the security disclosure and their help handling this case.
We're very thankful. 🙏

Happy coding! 🌸
