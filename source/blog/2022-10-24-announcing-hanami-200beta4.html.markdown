---
title: Announcing Hanami v2.0.0.beta4
date: 2022-10-24 13:15:00 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  Our last beta! Improved Hanami::Action memory usage, simplified body parser config, and a whole lot of polish.
---

Hello again, friends! We’re delighted to share the release of Hanami 2.0.0.beta4, the final release of our 2.0.0.beta series!

## Improved memory performance for Hanami::Action

Hanami::Action plays a key role in Hanami 2.0 apps, powering each of your HTTP endpoints. For this release we’ve made big improvements to the memory impact of subclassing Hanami::Action, with a memory reduction of over 5x for each subclass. This will help your Hanami apps retain a slim footprint even as they grow in size.

## Simplified body parser config

hanami-router’s body parsers are the middleware that parse incoming request bodies to turn them into Ruby structures that you can use within your actions. Now configuring a body parser has become easier than ever. No more requires or class names, just provide the name for your parser:

```ruby
module MyApp
  class App < Hanami::App
    config.middleware.use :body_parser, :json
  end
end
```

You can now also specify custom action formats and matching body parser configuration both in the same place:

```ruby
module MyApp
  class App < Hanami::App
    config.actions.format json: "application/json+scim"
    config.middleware.use :body_parser, [json: "application/json+scim"]
  end
end
```

## And a whole lot of polish!

We’ve spent much of this release’s development cycle getting everything as tidy as possible. Here are a few highlights:

- Added helpful output and help messages to all `hanami` CLI commands
- `hanami generate` now generates tests for slice-based components under `spec/slices/[slice_name]/`
- `Hanami::Settings` subclasses have a nested dry-types `Types` module auto-generated, for easy type-checking of settings: refer to `Types` inside your settings class and it’ll just work!
- `Hanami::Settings#inspect` hides values to prevent leakage of sensitive data, with `#inspect_values` as a way to see everything
- `request` and `response` objects inside Hanami::Action now share the same `session` and `flash` objects, ensuring all session changes are persisted regardless of how they’re made
- Accessing `session` and `flash` now raise a helpful error message if sessions are not configured
- `Hanami.app.configuration` is now `.config`, to better reflect usage in natural language

## 2.0.0 is coming!

This is the very last of our betas! From here, we expect to make two more releases:

- A 2.0.0.rc1 release candidate in two weeks
- The final 2.0.0 release in another two weeks

For these releases, we’ll be focused on minor bug fixes only, plus documentation and the 1.0 releases of our dry-rb gem dependencies. We’ll also be releasing a preview of our 2.0.0 user guide before the rc1 release.

All of this means you can look forward to a 2.0.0 release towards the end of November!

Between now and then, we need your help: please take the chance to test Hanami 2.0! Pull down this beta and give things a go, and let us know if you hit any issues.

## What’s included?

Today we’re releasing the following gems:

- hanami v2.0.0.beta4
- hanami-router v2.0.0.beta4
- hanami-controller v2.0.0.beta4
- hanami-cli v2.0.0.beta4
- hanami-reloader v1.0.0.beta4
- hanami-rspec v3.11.0.beta4 (it follows RSpec’s versioning)

For specific changes in this beta release, please see each gem’s own CHANGELOG.

## How can I try it?

```
⚡ gem install hanami --pre
⚡ hanami new bookshelf
⚡ cd bookshelf
⚡ bundle exec hanami --help
```

## Contributors

Thank you to these fine people for contributing to this release!

- [Marc Busqué](https://github.com/waiting-for-dev)
- [Sean Collins](https://github.com/cllns)
- [Luca Guidi](https://github.com/jodosha)
- [Benjamin Klotz](https://github.com/tak1n)
- [Tim Riley](https://github.com/timriley)
- [Peter Solnica](https://github.com/solnic)

## Thank you

Thank you as always for supporting Hanami!

We can’t wait to hear from you about this release, and we’re looking forward to sharing another update with you very soon. 🌸
