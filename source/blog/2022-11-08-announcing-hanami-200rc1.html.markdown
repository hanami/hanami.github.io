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

We’re very close to the stable version of Hanami 2!
We now consider Hanami 2 done.
Today’s Release Candidate (RC) 2.0.0.rc1 is hopefully the last step before we achieve this great milestone.

## Small changes

We’ve spent much of this release’s development cycle getting everything as tidy as possible. Here are a few highlights:

- Allow Rack middleware to be mounted directly inside routing scopes and slice scopes
- Introduce `Hanami::App.environment` (and `Hanami::Slice.environment`) to run setup code inside a particular environment only
- Simplify assignment of response format: `response.format = :json` (was `response.format = format(:json)`)
- Improve error messages for missing action class
- Remove duplicated `config.sessions` in favor of `config.actions.sessions`
- Fix `hanami routes` inspection of nested named routes
- Introduce `Hanami::Slice.stop` to properly shutdown all the application slices
- Expect/define nested slices to be within their parent’s namespace
- Use Zeitwerk to auto-load the `hanami` gem’s internal classes
- Remove `Hanami::Logger` from `hanami-utils` in favor of `Dry::Logger` from the new `dry-logger` new gem
- Ensure `Hanami::Utils::String.underscore` replaces `"."` (dot character) to `"_"` (underscore)

## 2.0.0 is coming!

**Expect 2.0.0 in two weeks.**

Since the last Hanami beta, we’ve released stable 1.0.0 versions of (almost) all dry-rb gems. The remaining few will come within the next two weeks.

This means that the Ruby ecosystem will soon have a complete set of modern, **stable** libraries and frameworks to build the next generation of applications.

Between now and then, we need your help: please take the chance to test Hanami 2.0! Pull down this RC and give things a go, and let us know if you hit any issues.

## What’s included?

Today we’re releasing the following gems:

- hanami v2.0.0.rc1
- hanami-cli v2.0.0.rc1
- hanami-controller v2.0.0.rc1
- hanami-router v2.0.0.rc1
- hanami-validations v2.0.0.rc1
- hanami-reloader v2.0.0.rc1 (it now follows Hanami’s versioning)
- hanami-rspec v2.0.0.rc1 (it now follows Hanami’s versioning)

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

We can’t wait to hear from you about this release candidate, and we’re looking forward to sharing another update with you in just two weeks! 🌸
