---
title: Announcing Hanami v1.0.0.beta2
date: 2017-03-02 13:33 UTC
tags: announcements
author: Luca Guidi & Oana Sipos
image: true
excerpt: >
  Small fixes preparing the stable 1.0.0 version
---
__From now on, **Hanami API's are stable and won't be changed until 2.0**.__

__The stable release (`v1.0.0`) will happen between the end of March and the beginning of April 2017, which coincides with the [Hanami season in Japan](http://www.japan-guide.com/sakura/). 🌸__

`v1.0.0.beta2` is a patch release for few bug fixes:

- Fixed migrations MySQL detection of username and password
- Fixed migrations creation/drop of a MySQL database with a dash in the name
- Ensure `db console` to work when Postgres connection URL is defined with `"postgresql://"` scheme
- Add `Action#unsafe_send_file` to send files outside of the public directory of a project
- Ensure HTTP Cache to not crash when HTTP\_IF\_MODIFIED\_SINCE and HTTP\_IF\_NONE\_MATCH have blank values
- Ensure to return 404 when `Action#send_file` cannot find a file with a globbed route
- Don't mutate Rack env when sending files
- Deep symbolize params from parsed body
- `Hanami::Router#recognize` must return a non-routeable object when the endpoint cannot be resolved
- Made Utils::Blank private API

### Minor Changes

For the entire list of changes, please have a look at our [CHANGELOG](https://github.com/hanami/hanami/blob/master/CHANGELOG.md) and [features list](https://github.com/hanami/hanami/blob/master/FEATURES.md).

## Released Gems

  * `hanami-1.0.0.beta2`
  * `hanami-model-1.0.0.beta2`
  * `hamami-controller-1.0.0.beta2`
  * `hanami-router-1.0.0.beta2`
  * `hanami-utils-1.0.0.beta2`

## Contributors

We're grateful for each person who contributed to this release. These lovely people are:

* [Anton Davydov](https://github.com/davydovanton)
* [Craig M. Wellington](https://github.com/tercenya)
* [Marcello Rocha](https://github.com/mereghost)
* [Marion Duprey](https://github.com/TiteiKo)
* [Oana Sipos](https://github.com/oana-sipos)
* [Sean Collins](https://github.com/cllns)
* [Semyon Pupkov](https://github.com/artofhuman)
* [Valentyn Ostakh](https://github.com/valikos)

## How To Update Your Project

If you're upgrading you project from `v0.9`, please have a look at the related [upgrade guide article](/guides/upgrade-notes/v100beta2).
