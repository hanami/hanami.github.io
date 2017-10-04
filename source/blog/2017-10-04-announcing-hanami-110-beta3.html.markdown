---
title: Announcing Hanami v1.1.0.beta3
date: 2017-10-04 12:12 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Fixes <code>hanami new</code> bug introduced by <code>v1.1.0.beta2</code>
---

Hello wonderful community!

On yesterday I released [`v1.1.0.beta2`](/blog/2017/10/03/announcing-hanami-110-beta2.html), but it was [broken](https://github.com/hanami/hanami/issues/838) 😭.

My sincere apologize, folks. 🙏

I quickly fixed the problem and released a new version: `v1.1.0.beta3`.

## Released Gems

  * `hanami-1.1.0.beta3`
  * `hanami-model-1.1.0.beta3`
  * `hanami-assets-1.1.0.beta3`
  * `hanami-cli-0.1.0.beta3`
  * `hanami-mailer-1.1.0.beta3`
  * `hanami-helpers-1.1.0.beta3`
  * `hanami-view-1.1.0.beta3`
  * `hamami-controller-1.1.0.beta3`
  * `hanami-router-1.1.0.beta3`
  * `hanami-validations-1.1.0.beta3`
  * `hanami-utils-1.1.0.beta3`

## How to try it

If you want to try with a new project:

```shell
gem install hanami --pre
hanami new bookshelf
```

If you want to upgrade your existing project, edit the `Gemfile`:

```ruby
# ...
gem "hanami",       "1.1.0.beta3"
gem "hanami-model", "1.1.0.beta3"
```

## What's next?

We'll release the stable release **later this month**, in the meantime, please try this beta and report issues.
Happy coding! 🌸
