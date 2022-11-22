---
title: "Hanami 2.0: Better, Faster, Stronger"
date: 2022-11-22 12:10 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  Hanami 2.0 opens a new chapter for the Ruby community.
---

After more than three years of work, Hanami 2.0 is here! With this release we enter a new phase of maturity for the framework, and open a new chapter for the Ruby community.

**Hanami 2.0 is better, faster, stronger.**

## Better

Since the beginning we’ve called Hanami a _modern web framework for Ruby_. These beginnings have given us a solid foundation for the journey to 2.0: our focus on **maintainability**, **testability**, and your ability to **scale your app** from a small service to a large monolith.

For 2.0 we’ve gone further. We’ve **listened** to our community, we’ve **simplified and simplified again**, we’ve **sought new approaches** for building apps, and we’ve **dared to challenge the status quo.**

In turn, **we want you to challenge yourself**. We want you to try something new, to experiment, to level up as an engineer. To dare to change, just as as we did. Without change, there is no challenge, and without challenge, there is no growth.

### What’s better with 2.0?

The core of Hanami 2.0 is now the `app/` directory. So familiar, yet so powerful. Here you can organize your code however you want, while still enjoying sensible defaults for common components. Then, as your app grows, you can take advantage of slices to separate your code into domains.

We’ve stripped everything back to its essence. Your new app is now refreshingly simple:

```ruby
require "hanami"

module Bookshelf
  class App < Hanami::App
  end
end
```

Hanami 2.0 delivers a framework that is at once minimal and powerful:

- The **new app core** offers advanced code loading capabilities centered around a container and components
- **Code autoloading** helps you work with minimal fuss
- New built-in **slices** offer gradual modularisation as your app grows
- An **always-there dependencies mixin** helps you draw clearer connections between your app’s components
- **Redesigned action classes** integrate seamlessly with your app’s business logic
- **Type-safe app settings** with dotenv integration ensure your app has everything it needs in every environment
- New **providers** manage the lifecycle of your app’s critical components and integrations
- **Top to bottom modularity** enables you to build apps of all kinds, including non-web apps
- Our **rewritten [getting started guide](https://guides.hanamirb.org/v2.0/introduction/getting-started/)** helps you get going with all of the above

There’s a lot to dig into for each of these. **[Check out the Highlights of Hanami 2.0](https://discourse.hanamirb.org/t/highlights-of-hanami-2-0/728)** to see more, including code examples.

## Faster

We’ve completely rewritten our HTTP routing engine, with benchmarks showing it [outperforms nearly all others](https://hanamirb.org/blog/2020/02/26/introducing-hanami-api/).

You will see actions served in **microseconds**:

```
[bookshelf] [INFO] [2022-11-22 09:48:41 +0100] GET 200 129µs 127.0.0.1 / -
```

When using Hanami in development, **your app will boot and reload instantly** thanks to our smart code loading. No matter how big your app grows, your console will load in milliseconds, and your tests will stay snappy. **No more waiting!**

## Stronger

This release is **a triumph of indie development.** Our small team of volunteer developers have put years of effort towards this release, and we’ve pulled it off!

We’ve also joined forces with the [dry-rb](https://dry-rb.org/) team. Together we’ve rebuilt Hanami on top of and around the dry-rb libraries. If you’ve ever had an interest in dry-rb, Hanami 2.0 gives you a curated experience and your easiest possible onramp.

Hanami 2.0 marks a **major moment for Ruby ecosystem diversity.** With this release we’re providing a distinct and compelling new vision for Ruby apps. With the backing of a compassionate and dedicated core team, you can feel confident Hanami will be here for the long run.

Why don’t you take a look? We’d love for you to join us!

You’re just a few commands away from building **better, faster, stronger apps**:

```shell
$ gem install hanami
$ hanami new bookshelf
$ cd bookshelf
$ bundle exec hanami server
```

Thank you from the Core Team of [Luca Guidi](https://github.com/jodosha), [Peter Solnica](https://github.com/solnic) and [Tim Riley](https://github.com/timriley).

Thank you also to these wonderful people for contributing to Hanami 2.0!

- [Andrew Croome](https://github.com/andrewcroome)
- [Benjamin Klotz](https://github.com/tak1n)
- [Lucas Mendelowski](https://github.com/lcmen)
- [Marc Busqué](https://github.com/waiting-for-dev)
- [Narinda Reeders](https://github.com/narinda)
- [Pat Allan](https://github.com/pat)
- [Philip Arndt](https://github.com/parndt)
- [Sean Collins](https://github.com/cllns)
- [Xavier Noria](https://github.com/fxn)

🌸
