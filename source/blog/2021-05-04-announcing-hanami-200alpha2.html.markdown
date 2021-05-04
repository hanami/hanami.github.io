---
title: Announcing Hanami v2.0.0.alpha2
date: 2021-05-04 21:30:00 GMT+11
tags: announcements
author: Tim Riley
image: true
excerpt: >
  NEXT preview of the 2.0 series. App simplification, new router, rewritten actions, fresh code reloading strategy.
---

Hello, Hanami community! It is my great honor to make my first post here and announce the release of Hanami v2.0.0.alpha2! 🎉

It’s been a little while since the last alpha release, but we’ve been hard at work, and the close collaboration between the Hanami, dry-rb, and rom-rb teams has been going exceedingly well. Together, we're delighted to present a **revolutionary vision** for Hanami 2.0! In this alpha, we have:

- A **completely rewritten application core** built around dry-system, offering advanced application-level state management and code loading capabilities
- An **always-there auto-injection mixin**, making it easy to model your behavior as functional, composable objects
- Built-in **application settings**, providing first-class support for your
- New **Slices** for organizing your application’s key areas of functionality
- A **reoriented Action class**, now truly stateless and oriented to work with application components as dependencies
- A **brand new, standalone view layer** boasting a full range of abstractions for better organising your view code
- A **blazing fast new router**
- A novel approach for **zero-boilerplate integration and configuration of application components**
- An opt-in mode to help you **manage all kinds of applications**, not just web applications
- And an **application template** to help you give all of this a try

That’s a lot of great stuff! Let’s dive in and take a look.

## New application core

Every Hanami 2.0 application now features a [dry-system](http://dry-rb.org/gems/dry-system) container at its core. From this simple app definition, you now get a next-level system for organizing your application components.

```ruby
module MyApp
  class Application < Hanami::Application
  end
end
```

This application class can then vend instances of your components, ready to use:

```ruby
Hanami.application["commands.create_article"] # => #<MyApp::Commands::CreateArticle>
```

You can also define **bootable** components in your `config/boot`, with their own lifecycle events and clear dependencies:

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

These bootable components can be resolved from the application container just like everything else:

```ruby
Hanami.application["some_service.client"] # => #<SomeService::Client api_key="xyz">
```

When a Hanami application boots in full, it will automatically register container entries for all the components represented by your Ruby source files:

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

As your application grows, this boot process will naturally slow; we've all experienced these frustratingly slow boot times for large Ruby applications. To help with this, Hanami 2.0 applications can be partially booted, requiring the bare minimum of files to setup the base container, and then lazy load your dependencies as required:

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

This allows your app to grow gracefully, giving you flexibility in when and how you load your code, as well as keeping the developer experience snappy at all times (the Hanami console will always partially boot the application, meaning you get to a prompt in under 1s, no matter how large the application!).

## Auto-injection mixin

A key benefit of the container is that it gives us abstract names (instead of concrete classes) for representing the application's components. Combined with Hanami 2's always-available `Deps` auto-injection mixin, this makes it easy to write classes oriented around dependency injection as the way to bring togehter different parts of the application:

```ruby
class CreateThing
  include Deps[service_client: "some_service.client"]

  def call(attrs)
    # Validate attrs, etc.

    service_client.create(attrs)
  end
end
```

With this code in place, a new instance of `CreateThing` will use the `:some_service` bootable component from our earlier examples:

```ruby
CreateThing.new # => #<CreateThing service_client=#<SomeService::Client api_key="xyz">>
```

This is exactly the same as when we resolve it from the container, such as when `"create_thing"` is used as a dependency of _another_ component:

```ruby
Hanami.application["create_thing"] # => #<CreateThing service_client=#<SomeService::Client api_key="xyz">>
```

Over in our unit tests, however, if we want to test `CreateThing` in isolation from our `service_client`, we can pass in an explicit replacement for this default dependency:

```ruby
subject(:create_thing) {
  CreateThing.new(service_client: service_client)
}

let(:service_client) { spy(:service_client) }
```

This low friction approach to dependency injection means we can much more readily decompose our application behaviour into easier-to-understand, easier-to-test single-responsibility components.

## Application settings

Application settings loading is now built-in. You can define these in `config/settings.rb`:

```ruby
Hanami.application.settings do
  setting :some_service_api_key
end
```

An optional type object can be provided as a second argument, to coerce and/or type check the setting values. This works well with [dry-types](https://dry-rb.org/gems/dry-types) type objects.

Settings are read from `.env*` files using [dotenv](https://github.com/bkeepers/dotenv).

The resulting settings object is a struct with methods matching your setting names. It's available as `Hanami.application.settings` as well as via the `"settings"` container registration, allowing you to auto-inject it into your application components as required.

## Application and slices

So far our examples have been from a single all-in-one application. But as our apps grow in complexity, it can be helpful to separate them into distinct, well-bounded high-level concerns. To serve in this role, Hanami 2 offers **Slices**.

Slices live inside the `slices/` directory. Each slice maps onto a single Ruby module namespace, and has its own dedicated container. For an application with the following directories:

```ruby
slices/
  admin/
  main/
  search/
```

It would have `Admin`, `Main`, and `Search` slices. Each slice container is loaded and managed exactly the same as the application container that we've described so far, so a class defined in `admin/create_article.rb` would be available from the `Admin::Slice` as `Admin::Slice["create_article"]`, and it can inject other dependencies from the admin slice:

```ruby
module Admin
  class CreateArticle
    include Deps["contracts.article_contract"] # defaults to Admin::Contracts::ArticleContract
  end
end
```

Each slice also automatically imports the core application slice, which by default contains some common app facilities (like the logger), the app's top-level bootable components, as well as any other classes you define in `lib/`. These are available under an `"application."` namespace in the slice's container registrations, making them just as easy to inject as other dependencies from within the slice:

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

Slices can also import _each other_:

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

With this, the slices themslves form their own clear graph of your application's high-level functionality.

While the slices are already incredibly powerful thanks to the built-in features of the container, we'll be spending future release cycles bolstering these even further, such as making it possible to load slices conditionally.

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

Every exposure's value is decorated by a matching view part class, which you can use to provide view-specific behaviour attached to specific domain objects, including anything possible from within the templates, such as rendering partials and accessing all aspects of the general view rendering context.

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

There’s almost no difference! Once you understand how to use `Hanami::View` once, you can use it everywhere. Even inside an Hanami app, where the app seamlessly integrates the views (in the case above, inferring the template name automatically, among other things), you can still access the full extent of the view configuration, allowing you to ”eject” from the configured defaults if you ever need.

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

## What's nexet?

- Coming next:
  - More refinement
  - CLI with generators
  - ROM integration
  - Pls follow our trello board
