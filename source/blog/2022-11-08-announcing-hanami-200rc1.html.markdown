---
title: Announcing Hanami v2.0.0.rc1
date: 2022-11-08 08:24:53 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  First Release Candidate! Preparing for stable release.
---

Hello, folks!
We're close to the stable version of Hanami 2!
We consider Hanami 2 done.
Today's Release Candidate (RC) 2.0.0.rc1 is hopefully the last step before to achieve this great milestone.

## Small changes

We've spent much of this release's development cycle getting everything as tidy as possible. Here are a few highlights:

- Use Zeitwerk to auto-load Hanami
- Introduce `Hanami::Slice.stop` to properly shutdown all the application slices
- Ensure to properly mount Rack middleware in routing scope and slice
- Simplify and clarify usage of `Hanami::Config#enviroment`
- Improve error message for missing action class
- Expect nested slices to use parent’s namespace
- Remove duplicated configuration `config.session` and keep `config.actions.sessions`
- Fixed `hanami routes` inspection of nested named routes
- Simplify assignment of response format: `response.format = :json` (was `response.format = format(:json)`)
- Removed `Hanami::Logger` from `hanami-utils` in favor of `Dry::Logger` from `dry-logger` new gem
- Ensure `Hanami::Utils::String.underscore` to replace `"."` (dot character) to `"_"` (underscore)

## 2.0.0 is coming!

**Expect 2.0.0 in two weeks.**

Since last Hanami beta version, we released stable versions of all dry-rb gems.

Soon, the Ruby ecosystem will have set of modern, **stable** libraries and frameworks to build the next generation applications.

Between now and then, we need your help: please take the chance to test Hanami 2.0! Pull down this RC and give things a go, and let us know if you hit any issues.

## What’s included?

Today we’re releasing the following gems:

- hanami v2.0.0.rc1
- hanami-cli v2.0.0.rc1
- hanami-controller v2.0.0.rc1
- hanami-router v2.0.0.rc1
- hanami-validations v2.0.0.rc1
- hanami-reloader v2.0.0.rc1 (it now follows Hanami versioning)
- hanami-rspec v2.0.0.rc1 (it now follows Hanami versioning)

For specific changes in this RC release, please see each gem’s own CHANGELOG.

## How can I try it?

```shell
⚡ gem install hanami --pre
⚡ hanami new bookshelf
⚡ cd bookshelf
⚡ bundle exec hanami --help
```

## Contributors

Thank you to these fine people for contributing to this release!

- [Luca Guidi](https://github.com/jodosha)
- [Tim Riley](https://github.com/timriley)
- [Peter Solnica](https://github.com/solnic)
- [Andrew Croome](https://github.com/andrewcroome)
- [Benjamin Klotz](https://github.com/tak1n)
- [Xavier Noria](https://github.com/fxn)

## Thank you

Thank you as always for supporting Hanami!

We can’t wait to hear from you about this release, and we’re looking forward to sharing another update with you very soon. 🌸
