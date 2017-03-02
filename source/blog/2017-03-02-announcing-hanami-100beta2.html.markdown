---
title: Announcing Hanami v1.0.0.beta2
date: 2017-03-02 13:33 UTC
tags: announcements
author: Luca Guidi & Oana Sipos
image: true
excerpt: >
  Small fixes preparing the stable 1.0.0 version
---

## Minor Changes

`v1.0.0.beta2` is a patch release for few bug fixes:

- Fixed migrations MySQL detection of username and password
- Fixed migrations creation/drop of a MySQL database with a dash in the name
- Ensure `db console` to work when Postgres connection URL is defined with `"postgresql://"` scheme
- Allow to define Postgres connection URL as `"postgresql:///mydb?host=localhost&port=6433&user=postgres&password=testpasswd"`
- Add `Action#unsafe_send_file` to send files outside of the public directory of a project
- Ensure HTTP Cache to not crash when `HTTP\_IF\_MODIFIED\_SINCE` and `HTTP\_IF\_NONE\_MATCH` have blank values
- Ensure to return 404 when `Action#send_file` cannot find a file with a globbed route
- Flash messages survive after a redirect
- Don't mutate Rack env when sending files
- Deep symbolize params from parsed body
- `Hanami::Router#recognize` must return a non-routeable object when the endpoint cannot be resolved
- Made `Utils::Blank` private API

## Released Gems

  * `hanami-1.0.0.beta2`
  * `hanami-model-1.0.0.beta2`
  * `hamami-controller-1.0.0.beta2`
  * `hanami-router-1.0.0.beta2`
  * `hanami-utils-1.0.0.beta2`

## Contributors

We're grateful for each person who contributed to this release. These lovely people are:

* [Alfonso Uceda](https://github.com/AlfonsoUceda)
* [Anton Davydov](https://github.com/davydovanton)
* [Craig M. Wellington](https://github.com/tercenya)
* [Marcello Rocha](https://github.com/mereghost)
* [Marion Duprey](https://github.com/TiteiKo)
* [Marion Schleifer](https://github.com/marionschleifer)
* [Oana Sipos](https://github.com/oana-sipos)
* [Sean Collins](https://github.com/cllns)
* [Semyon Pupkov](https://github.com/artofhuman)
* [Valentyn Ostakh](https://github.com/valikos)

## How To Update Your Project

Edit your `Gemfile`:

```ruby
gem 'hanami', '1.0.0.beta2'
gem 'hanami-model', '1.0.0.beta2'
```

Then run `bundle update hanami hanami-model`.

## What's Next?

[Since `v1.0.0.beta1`](/blog/2017/02/14/announcing-hanami-100beta1.html), **Hanami API's are stable and won't be changed until 2.0**.

We'll keep to release small _beta_/_rc_ versions to integrate fixes for reported bugs.

The final stable release (`v1.0.0`) will happen between the end of March and the beginning of April 2017, which coincides with the [Hanami season in Japan](http://www.japan-guide.com/sakura/). 🌸
