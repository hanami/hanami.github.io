---
title: Announcing Hanami v2.1.0.beta1
date: 2023-06-29 12:00 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  Introducing hanami-view and sharing our plans for v2.1
---

Since the release of 2.0, we’ve been hard at work completing our vision for full stack Hanami apps. Today we’re excited to advance our view layer and introduce hanami-view with the release of 2.1.0.beta1.

Just like our actions, views are standalone, callable objects. They can work with their arguments and dependencies to prepare exposures to pass to a template for rendering:

```ruby
# app/views/posts/index.rb
module MyApp
  module Views
    module Posts
      class Index < MyApp::View
        include Deps["posts_repo"]

        expose :posts do |page:|
          posts_repo.listing(page:)
        end
      end
    end
  end
end
```

```html
<h1>Posts</h1>

<%= posts.each do |post| %>
  <h2><%= post.title %></h2>
<% end %>
```

Views are automatically paired with matching actions, so they're ready for you to render:

```ruby
# app/actions/posts/index.rb

module MyApp
  module Actions
    module Posts
      class Index < MyApp::Action
        def handle(request, response)
          request.params => {page:}

          # view is a ready-to-go instance of MyApp::Views::Posts::Index
          response.render(view, page:)
        end
      end
    end
  end
end
```

Hanami views are built on top of [Tilt](https://github.com/jeremyevans/tilt), giving them support for a wide range of template engines. For HTML templates, we provide first-party support for ERB (using a brand new implementation for hanami-view), Haml and Slim.

Hanami will generate matching views when you generate your actions with the `hanami generate action` command. You can also generate views directly via `hanami generate view`.

Along with views, we’re also introducing a range of built-in helpers, giving you convenient ways to create forms and programatically generate HTML. You can also provide your own helpers inside a `Views::Helpers` module within each app and slice namespace.

You can write your own helpers using natural, expressive Ruby, including straightforward yielding of blocks:

```ruby
# app/views/helpers.rb

module MyApp
  module Views
    module Helpers
      # Feel free to organise your helpers into submodules as appropriate

      def warning_box
        # `tag` is our built-in HTML builder helper
        tag.div(class: "warning") do
          # Yielding implicitly captures content from the block in the template
          yield
        end
      end
    end
  end
end
```

```html
<h1>Posts</h1>

<%= warning_box do %>
  <h2>This section is under construction</h2>
<% end %>
```

hanami-view is the successor to dry-view, a view system honed over many years of real-world use. Along with the above, it includes even more powerful tools for helping you build a clean and maintainable view layer, such as custom view parts and scopes.

We’re working on updating our getting started guide to include an introduction to views, and we’ll release this as soon as its available.

In the meantime, we’re making this 2.1 beta release so you can give views a try and make sure they’re ready for prime time!

## What’s included?

Today we’re releasing the following gems:

- hanami v2.1.0.beta1
- hanami-cli v2.1.0.beta1
- hanami-controller v2.1.0.beta1
- hanami-router v2.1.0.beta1
- hanami-validations v2.1.0.beta1
- hanami-utils v2.1.0.beta1
- hanami-view v2.1.0.beta1
- hanami-reloader v2.1.0.beta1
- hanami-rspec v2.1.0.beta1
- hanami-webconsole v2.1.0.beta1

For specific changes in this beta release, please see each gem’s own CHANGELOG.

## How can I try it?

```shell
> gem install hanami --pre
> hanami new my_app
> cd my_app
> bundle exec hanami --help
```

## What’s next for 2.1?

Alongside our work on views, we’ve been preparing Hanami’s front end assets support. This will be based on esbuild, will integrate seamlessly with our views, and even support you splitting your front end assets by slice.

We plan to release this as hanami-assets in an upcoming Hanami v2.0.beta2 release. At this point, you’ll be able to build Hanami apps with a complete front end.

After a short testing period, we’ll release all of these as 2.1.0.

## Contributors

Thank you to these fine people for contributing to this release!


- [Luca Guidi](https://github.com/jodosha)
- [Tim Riley](https://github.com/timriley)
- [dsinero](https://github.com/dsinero)
- [Masanori Ohnishi](https://github.com/MasanoriOnishi)

## Thank you

Thank you as always for supporting Hanami!

We’re excited to be expanding the Hanami vision again, and we can’t wait to hear from you about this beta! 🌸

















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
