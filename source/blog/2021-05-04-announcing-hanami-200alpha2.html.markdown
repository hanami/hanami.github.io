---
title: Announcing Hanami v2.0.0.alpha2
date: 2021-05-04 13:45:00 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  After two years of work, presenting a reviolutionary new vision for Hanami 2.0.
---

Hello, Hanami community! It is my great honor to make my first post here and announce the release of Hanami v2.0.0.alpha2! 🎉

It’s been a little while since [the last alpha release](https://hanamirb.org/blog/2019/01/30/announcing-hanami-200alpha1/), but we’ve been hard at work, and the close collaboration between the Hanami, dry-rb, and rom-rb teams has been going exceedingly well. Together, we’re delighted to present a **revolutionary vision** for Hanami 2.0! In this alpha, we have:

- A **completely rewritten application core**, offering advanced application-level state management and code loading capabilities
- An **always-there auto-injection mixin**, making it easy to model your behavior as functional, composable objects
- Built-in **application settings** with first-class support
- New **Slices** for organizing your application’s key areas of functionality
- A **reoriented Action class**, now truly stateless and oriented to work with application components as dependencies
- A **brand new, standalone view layer** boasting a full range of abstractions for better organising your view code
- A **blazing fast new router**
- A novel approach for **zero-boilerplate integration and configuration of application components**
- An opt-in mode to help you **manage all kinds of applications**, not just web applications
- And an **application template** to help you give all of this a try

That’s a lot of great stuff! Let’s dive in and take a look.

## New application core

Every Hanami 2.0 application provides a next-level system for organizing your application’s components. After defining your application, it can vend ready-to-use instances of your application’s objects.

```ruby
module MyApp
  class Application < Hanami::Application
  end
end

Hanami.application["commands.create_article"] # => #<MyApp::Commands::CreateArticle>
```

You can also define **bootable** components in your `config/boot/`, with their own lifecycle events and clear dependencies.

```ruby
Hanami.application.register_bootable :some_service do |container|
  init do
    require "some_service/client"
  end

  start do
    register "some_service.client", SomeService::Client.new(
      api_key: container[:settings].some_service_api_key
    )
  end
end
```

You can then get these bootable components from the application, just like any other.

```ruby
Hanami.application["some_service.client"] # => #<SomeService::Client api_key="xyz">
```

When a Hanami application boots in full, it will automatically register entries for all components represented by your Ruby source files.

```ruby
Hanami.boot

Hanami.application.keys
# => [
#   "logger",
#   "some_service.client",
#   "commands.create_article",
#   "commands.update_article",
#   "commands.delete_article",
#   ...
# ]
```

As your application grows, this boot process will naturally slow; we’ve all experienced the frustratingly long wait as large Ruby applications boot. To help with this, Hanami 2.0 applications can be **partially booted**, requiring a bare minimum of files, then lazy load your components as they’re accessed.

```ruby
Hanami.init

Hanami.application.keys
# => [
#   "logger",
# ]

Hanami.application["commands.create_article"]

Hanami.application.keys
# => [
#   "logger",
#   "commands.create_article",
# ]
```

This allows your app to grow gracefully, gives you flexibility in when and how you load your code, and keeps the developer experience snappy all the while. The Hanami console, for example, only partially boots the application, meaning **you get a prompt in under 1s, no matter how large the application!**

## Auto-injection mixin

With application components addressable via abstract identifiers (instead of concrete class names), you can then use Hanami 2.0’s always-available `Deps` auto-injection mixin to write classes oriented around dependency injection as the way to compose different application behaviors.

```ruby
class CreateThing
  include Deps[service_client: "some_service.client"]

  def call(attrs)
    # Validate attrs, etc.

    service_client.create(attrs)
  end
end
```

With this code in place, a new instance of `CreateThing` will use the `:some_service` bootable component from our earlier examples.

```ruby
CreateThing.new # => #<CreateThing service_client=#<SomeService::Client api_key="xyz">>
```

This is exactly the same as when you resolve it from the container, such as when `"create_thing"` is used as a dependency of _another_ component.

```ruby
Hanami.application["create_thing"] # => #<CreateThing service_client=#<SomeService::Client api_key="xyz">>
```

Over in the unit tests, however, if you want to test `CreateThing` in isolation from the `service_client`, you can pass in an explicit replacement for this default dependency.

```ruby
subject(:create_thing) {
  CreateThing.new(service_client: service_client)
}

let(:service_client) { spy(:service_client) }
```

This low friction approach to dependency injection means you can much more readily decompose our application behaviour into smaller, easier-to-understand, easier-to-test, single-responsibility components.

## Application settings

Application settings loading is now built-in. You can define these in `config/settings.rb`:

```ruby
Hanami.application.settings do
  setting :some_service_api_key
end
```

An optional type object can be provided as a second argument, to coerce and/or type check the setting values. This works well with [dry-types](https://dry-rb.org/gems/dry-types) type objects.

Settings are read from `.env*` files using [dotenv](https://github.com/bkeepers/dotenv).

The resulting settings object is a struct with methods matching your setting names. It’s available as `Hanami.application.settings` as well as via the `"settings"` component, allowing you to auto-inject it into your application components as required.

## Application and slices

So far our examples have been from a single all-in-one application. But as our apps grow in complexity, it can be helpful to separate them into distinct, well-bounded high-level concerns. To serve in this role, Hanami 2 offers **Slices**.

Slices live inside the `slices/` directory. Each slice maps onto a single Ruby module namespace, and has its own dedicated instance for managing its components.

For an application with the following directories:

```ruby
slices/
  admin/
  main/
  search/
```

It would have corresponding `Admin`, `Main`, and `Search` slices. Each slice is loaded and managed just like the application itself, so a class defined in `admin/create_article.rb` would be available from `Admin::Slice` as `Admin::Slice["create_article"]`, and can in turn inject other dependencies from the admin slice.

```ruby
module Admin
  class CreateArticle
    include Deps["contracts.article_contract"] # defaults to Admin::Contracts::ArticleContract
  end
end
```

Each slice also automatically imports the components from the application, which contains some common facilities (like the logger), the app’s top-level bootable components, as well as any other classes you define in `lib/`. These are available under an `"application."` namespace in the slice, making it just as easy to inject these as dependencies.

```ruby
module Admin
  class CreateArticle
    include Deps[
      "contracts.article_contract",
      "application.logger",
    ]

    def call
      logger.info "creating article"
      # ...
    end
  end
end
```

Slices can also _import each other._

```ruby
module MyApp
  class Application < Hanami::Application
    config.slice :admin do
      # Inside `Admin`, registrations from the `Search` slice will be available under the `"search."` container namespace
      import :search
    end
  end
end
```

With this, the slices themslves form their own clear graph of your application’s high-level functionality.

While the slices are already incredibly powerful thanks to the built-in features of the container, we’ll be spending future release cycles bolstering these even further, such as making it possible to load slices conditionally.

## Functional Hanami::Action

`Hanami::Action` has been reoriented to provide immutable, callable action classes that fit well with all other parts of the new framework. Actions can declare dependencies to interact with the rest of the application, access the request and prepare a response in their `#handle` method, then the class will take care of the rest.

```ruby
module Admin
  module Actions
    module Articles
      class Show < Admin::Action
        include Deps["article_repo"]

        def handle(req, res)
          article = article_repo.find(req.params[:id])

          res.body = JSON.generate(article)
        end
      end
    end
  end
end
```

Actions are still callable and Rack-compatible, and continue to offer the same range of HTTP-related features from their 1.x counterparts, reoriented to fit this new structure.

## Brand new view layer

Hanami 2.0 will sport an entirely new view layer, with [dry-view](https://dry-rb.org/gems/dry-view) joining the Hanami family as the new hanami-view. With years of development behind it, it offers a sophisticated set of abstractions for designing well-factored views.

A view in Hanami 2.0 is a standalone, callable class that can declare dependencies to interact with the rest of the application (are you catching the theme here?). It can access parameters and then prepare named exposures to make available to its corresponding template.

```ruby
module Admin
  module Views
    module Articles
      class Show < Admin::View
        include Deps["article_repo"]

        expose :article do |id:|
          article_repo.find(id)
        end
      end
    end
  end
end
```

Every exposure’s value is decorated by a matching view part class, which you can use to provide view-specific behaviour attached to specific domain objects, including anything possible from within the templates, such as rendering partials and accessing all aspects of the general view rendering context.

```ruby
module Admin
  module View
    module Parts
      class Article < Admin::Part
        def preview_text
          body_text.to_s[0..300]
        end

        def render_social_preview
          render(:social_preview, title: title, text: preview_text)
        end
      end
    end
  end
end
```

Views also integrate nicely with actions, allowing you to keep your actions clean and focused on HTTP responsibilities only.

```ruby
module Admin
  module Actions
    module Articles
      class Show < Admin::Action
        include Deps[view: "views.articles.show"]

        def handle(req, res)
          res.render view, id: req.params[:id]
        end
      end
    end
  end
end
```

Since views are independent, addressable, callable objects just like any other component within an Hanami application, they can also be put to a wide range of uses alongside the standard rendering of web page HTML, such as rendering emails or even preparing API responses.

## Zero-boilerplate integration of application components

A strong focus of our effort in building Hanami 2.0 has been to allow each component, such as a view or action, to remain useful outside of Hanami, while also fitting seamlessly when used within a full Hanami application. A view used outside of Hanami, for example, looks like this:

```ruby
class MyView < Hanami::View
  config.template = "my_view"
end
```

And this same view used within Hanami looks like this:

```ruby
class MyView < Hanami::View
end
```

There’s almost no difference! Once you understand how to use `Hanami::View` in one place, you can use it everywhere. Even inside an Hanami app, where the app seamlessly integrates the views (in the case above, inferring the template name automatically, among other things), you can still access the full extent of the view configuration, allowing you to ”eject” from the configured defaults if you ever need.

## Blazing fast new router

With all your actions and views in place, you’ll want a way to write them up to URLs. Hanami 2.0’s router will offer a familiar DSL to make this happen.

```ruby
Hanami.application.routes do
  mount :main, at: "/" do
    # Will resolve "actions.home.index" from the Main slice
    root to: "home#index"
  end

  mount :admin, at: "/admin" do
    # Will resolve "actions.home.index" from the Admin slice
    root to: "home#index"
  end
end
```

The engine underpinning the new router also offers amazing performance, with Hanami::API benchmarks showing it [outperforming nearly all others](https://hanamirb.org/blog/2020/02/26/introducing-hanami-api/).

## A framework for all applications

Many of the new features we’ve seen so far would empower any kind of application, not just web applications. So with this alpha, we’re making the first release of a truly “unbundled” Hanami, with the hanami-controller, hanami-router, and hanami-view gem dependencies being moved outside of the main gem and into the Gemfiles of the generated applications.

This means you can now use the hanami gem to help you better organise any kind of Ruby application.  All you’ll need to do is opt out of the web mode when booting your application.

```
Hanami.boot web: false
```

In future releases, we’ll work to make this an even smoother process.

## What’s included?

Today we’re releasing the following gems:

- `hanami` v2.0.0.alpha2
- `hanami-cli` v2.0.0.alpha2
- `hanami-view` v2.0.0.alpha2
- `hanami-controller` v2.0.0.alpha2
- `hanami-router` v2.0.0.alpha5
- `hanami-utils` v2.0.0.alpha2

## How can I try it?

We’ve prepared an [Hanami 2 application template](https://github.com/hanami/hanami-2-application-template) which you can clone to get started with an app and try everything we’ve shared today. The template provides it’s own installation instructions and scripts, and prepares a full stack web application ready for you to use.

There’s so much more to this release than we’ve been able to share in this brief post, so we’d love for you to try everything out. We can’t wait to hear your thoughts!

## What’s next?

While we’ve covered so much ground since the last alpha, there are still many rough edges to smooth over, as well as a few big pieces to put in place, such as an application CLI with generators, first-class integration with [rom-rb](https://rom-rb.org) for a persistence layer, front-end assets integration, and a standard collection of view helpers.

If you’d like to follow along, we’re tracking the remaining work in our public [Hanami 2.0 trello board](https://trello.com/b/lFifnBti/hanami-20).

Thank you for your continued interest in Hanami, and for your support of a diverse, flourishing Ruby ecosystem! 🌸
