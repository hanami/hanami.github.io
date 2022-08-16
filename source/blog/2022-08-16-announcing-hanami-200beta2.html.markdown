---
title: Announcing Hanami v2.0.0.beta2
date: 2022-08-16 13:30:00 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  Slice and action generators, middlwares inspection, and conditional slice loading
---

Hello again, friends! We’re excited to share our release of Hanami 2.0.0.beta2!

## Slice and action generators

Last month we reintroduced the `hanami new` app generator, and this time around we’re happy to add another couple of generators.

`hanami generate slice` will generate a new slice into `slices/`. Right now it gives you a base action class and an `actions/` directory for your own actions.

To create those actions, you can use `hanami generate action`. This generates action classes into `app/actions/` by default, but you can also use `--slice [slice_name]` to specify a particular slice as the target.

## Middlewares inspection

To go along with our `hanami routes` CLI command, we’ve added `hanami middlewares`, which displays the middlewares you’ve configured for your Hanami rack app. This will be useful for understanding the flow of requests through middleware stacks, especially for stacks with middleware active at particular route prefixes.

For a new Hanami app with cookie sessions configured, it’ll look like this:

```
> hanami middlewares

/    Dry::Monitor::Rack::Middleware (instance)
/    Rack::Session::Cookie
```

You can also provide `--with-arguments` to see the arguments provided for each middlware:

```
> hanami middlewares --with-arguments

/    Dry::Monitor::Rack::Middleware (instance) args: []
/    Rack::Session::Cookie args: [{:secret=>"abc123"}]
```

## Conditional slice loading

Slices are one of the superpowers we’re introducing with Hanami 2: by organising your application logic into distinct slices, you can create a truly modular app structure. Today with beta2 we’re introducing conditional slice loading, which will allow you to take advantage of that modularity by loading different sets of slices for different deployed workloads.

You can specify the slices to load with a new `config.slices` setting:

```ruby
# config/app.rb

module AppName
  class App < Hanami::App
    config.slices = %w[blog shop]
  end
end
```

You can also populate this setting directly via an `HANAMI_SLICES` environment variable, using commas to separate the slice names, e.g. `HANAMI_SLICES=blog,shop`.

Any slices not incuded in this list will be completely ignored: their slice class will not be loaded, nor any of their other Ruby source files; effectively, they will not exist.

Specifying slices like this will **improve boot time and minimize memory usage** for specific workloads (imagine a job runner that needs only a single slice), as well as help ensure clean boundaries between your slices.

## What’s included?

Today we’re releasing the following gems:

- `hanami` v2.0.0.beta2
- `hanami-rspec` v3.11.0.beta2 (it follows RSpec’s versioning)
- `hanami-cli` v2.0.0.beta2
- `hanami-router` v2.0.0.beta2

For specific changes from the last alpha release, please see each gem’s own CHANGELOG.

## How can I try it?

```
⚡ gem install hanami --pre
⚡ hanami new bookshelf
⚡ cd bookshelf
⚡ bundle exec hanami --help
```

## Contributors

Thank you to these fine people for contributing to this release!

- [Luca Guidi](https://github.com/jodosha)
- [Marc Busqué](https://github.com/waiting-for-dev)
- [Seb Wilgosz](https://github.com/swilgosz)
- [Tim Riley](https://github.com/timriley)

## Thank you

Thank you as always for supporting Hanami!

We can’t wait to hear from you about this release, and we’re looking forward to checking in with you again soon. 🌸
