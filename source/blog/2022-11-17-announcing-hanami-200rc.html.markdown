---
title: "Hanami 2.0: Better, Faster, Stronger"
date: 2022-11-17 08:24:53 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  Hanami 2.0 opens a new season for the Ruby Community.
---

After more than three years of work, Hanami 2.0 is here! We're entering the maturity phase of our framework and a new season for the Ruby Community.

**Hanami 2.0 is better, faster, stronger.**

## Better

Since its beginning Hanami is _modern web framework for Ruby_. We have started this 2.0 journey on solid foundations: our focus for **maintainability**, **testability**, the ability to **scale up your code base** from a small service to a large monolith.

We went beyond that. We spent time to **listen** to our Community, **to simplify and simplify again**, to **try new approaches** to build apps, to **dare to challenge** the status quo.

**We want you to challenge yourself**. To try, to experiment, to level up as engineer, to dare to change as we did.

**Without change, there is no challenge and without challenge, there is no growth.**

### What’s new with 2.0?

The core of Hanami 2.0 is the `app/` directory. When your codebase will grow, you have the opportunity of using slices to separate code in domains.

The application (`config/app.rb`) is now simple, easy on newcomers eyes:

```ruby
require "hanami"

module Bookshelf
  class App < Hanami::App
  end
end
```

This approach is minimal, yet powerful:

- This **new app core** offers advanced code structure system with [container and components](https://guides.hanamirb.org/v2.0/app/container-and-components/)
- [Code autoloading](https://guides.hanamirb.org/v2.0/app/autoloading/) capabilities
- New built-in **[slices](https://guides.hanamirb.org/v2.0/app/slices/)** for gradual modularisation as your app grows
- An **always-there [dependencies mixin](https://guides.hanamirb.org/v2.0/app/container-and-components/#injecting-dependencies-via-deps)** (`Bookshelf::Deps`), helping you draw clearer connections between your app's components and slices
- **Redesigned action classes** that integrate seamlessly with your app's business logic
- **Cached components** (e.g. actions) that help to **save memory**
- **Type-safe app [settings](https://guides.hanamirb.org/v2.0/app/settings/)** with dotenv integration, ensuring your app has everything it needs in every environment
- New **[providers](https://guides.hanamirb.org/v2.0/app/providers/)** for managing the lifecycle of your app's critical components and integrations
- **Full modularity** that allows to build **headless** (non-web) **applications**.
- A **rewritten [getting started guide](https://guides.hanamirb.org/v2.0/introduction/getting-started/)** to help you get going with all of the above

✂️✂️✂️

### Advanced application core

At the heart of every Hanami 2.0 app is an advanced code loading system. It all begins when you run `hanami new` and have your app defined in `config/app.rb`:

From here you can build your app's logic in `app/`, and then boot the app, which loads all your code, as part of running a web server. This is the usual story.

In Hanami 2.0, your app can do so much more. You can use the app object itself to load and return any individual component:

```ruby
# Return an instance of the action in app/actions/home/show.rb

Hanami.app["actions.home.show"] # => #<Bookshelf::Actions::Home::Show>
```

You can also choose to _prepare_ rather than fully boot your app. This loads the minimal set of files required for your app to load individual components on demand. This is how the Hanami console launches, and how your app is prepared for running unit tests.

This means your experience interacting with your app remains as snappy as possible, even as it grows to many hundreds or thousands of components. Your Hanami console will always load within milliseconds, and the fastest possible tests will keep you squarely in the development flow.

### Always-there dependencies mixin

No class is an island. Any Ruby app needs to bring together behavior from multiple classes to deliver features to its users. With Hanami 2.0’s new **Deps mixin**, object composition is now built-in and amazingly easy to use.

```ruby
module Bookshelf
  module Emails
    class DailyUpdate
      include Deps["email_client"]

      def deliver(recipient)
        email_client.send_email(to: recipient, subject: "Your daily update")
      end
    end
  end
end
```

You can `include Deps` in any class within your Hanami app. Provide the keys for the components you want as dependencies, and they'll become automatically available to any instance methods.

Behind the scenes, the Deps mixin creates an `#initialize` method that expects these dependencies as arguments, then provides the matching objects from your app as default values.

This also makes isolated testing a breeze:

```ruby
RSpec.describe Bookshelf::Emails::DailyUpdate do
  subject(:daily_update) {
    # (Optionally) provide a test double to isolate email delivery in tests
    described_class.new(email_client: email_client)
  }

  let(:email_client) { instance_spy(:email_client, Bookshelf::EmailClient) }

  it "delivers the email" do
    daily_update.deliver("jane@example.com")

    expect(email_client)
      .to have_received(:send_email)
      .with(hash_including(to: "jane@example.com"))
  end
end
```

You can specify as many dependencies as you need to the Deps mixin. With it taking pride of place at the top of each class, it will help you as quickly identify exactly how each object fits within the graph of your app's components.

The Deps mixin makes object composition natural and low-friction, making it easy for you to break down unwieldy classes. Before long you’ll be creating more focused, reusable components, easier to test and easier to understand. Once you get started, you’ll never want to go back!

### Redesigned action classes

From routes we move to actions, the classes for handling individual HTTP endpoints. In Hanami 2.0 we’ve redesigned actions to fit seamlessly with the rest of your app.

In your actions you can now `include Deps` like any other class, which helps in keeping your business logic separate and your actions focused on HTTP interactions only:

```ruby
module Bookshelf
  module Actions
    module Books
      class Show < Bookshelf::Action
        include Deps["book_repo"]

        params do
          required(:slug).filled(:string)
        end

        def handle(request, response)
          book = book_repo.find_by_slug(request.params[:slug])

          response.body = book.to_json
        end
      end
    end
  end
end
```

Actions in Hanami still provide everything you need for a full-featured HTTP layer, including built-in parameter validation, Rack integration, session and cookie handling, flash messages, before/after callbacks and more.

### Type-safe app settings

For your app to do its thing, you'll want to give it various settings: behavioral toggles, API keys, external system URLs and the like. Hanami 2.0 provides a built-in settings class along with [dotenv][dotenv] integration for loading these settings from `.env*` files in local development.

You can define your settings along with type constructors in `config/settings.rb`:

```ruby
module Bookshelf
  class Settings < Hanami::Settings
    setting :email_client_api_key, constructor: Types::String
    setting :emails_enabled, constructor: Types::Params::Bool
  end
end
```

Your settings are then available as a `"settings"` component for you to use from anywhere in your app:

```ruby
# Given ENV["EMAILS_ENABLED"] = "true"
Hanami.app["settings"].emails_enabled # => true
```

This means you can include `"settings"` in a list of `Deps` and access your settings from any class:

```ruby
module Bookshelf
  module Emails
    class DailyUpdate
      include Deps["email_client", "settings"]

      def deliver(recipient)
        return unless settings.emails_enabled
        # ...
      end
    end
  end
end
```

Hanami loads your settings early during the app’s boot process and will raise an error for any settings that fail to meet their type expectations, giving you early feedback and ensuring your app doesn’t boot in a potentially invalid state.

[dotenv]: https://github.com/bkeepers/dotenv

### Providers

So far we’ve seen how your classes and settings can be accessed as components in your app. But what about components that require special handling before they’re registered? For these, Hanami 2.0 introduces providers. Here’s one for the `"email_client"` component we used earlier, in `config/providers/email_client.rb`:

```ruby
Hanami.app.register_provider :email_client do
  prepare do
    require "acme_email/client"
  end

  start do
    # Grab our settings component from the app (the "target" for this provider)
    settings = target["settings"]

    client = AcmeEmail::Client.new(
      api_key: settings.email_client_api_key,
      default_from: "no-reply@bookshelf.example.com"
    )

    register "email_client", client
  end
end
```

Every provider can use its own set of `prepare`/`start`/`stop` lifecycle steps, which is useful for setting up and using heavyweight components, or components that use tangible resources like database connections.

You can interact directly with these providers and their components, giving you to access to parts of your app in situations where you may only need a single component. A common example here would be running database migrations or precompiling static assets, which are tasks that can run in isolation from the rest of your app.

### Slices

As your app grows up, you may want to draw clear boundaries between its major areas of concern. For this, Hanami 2.0 introduces slices, a built-in facility for organising your code, encouraging maintainable boundaries, and creating operational flexibility.

To get started with a slice, create a directory under `slices/` and then start adding your code there, using a matching Ruby namespace. It’s that simple! Here’s a class that imports books for our bookshelf app:

```ruby
# slices/feeds/process_feed.rb
module Feeds
  class ProcessFeed
    def call(feed_url)
      # ...
    end
  end
end
```

Each slice has its own slice class that behaves just like a miniature Hanami app:

```ruby
Feeds::Slice["process_feed"] # => #<Feeds::ProcessFeed>
```

Every slice imports some basic components from the app, like the `"settings"`, `"logger"` and `"inflector"`, and slices can also be configued to import components from each other. If we added an admin slice to our app, we could allow it to invoke feed processing by specifying an import in the slice class at `config/slices/admin.rb`:

```ruby
module Admin
  class Slice < Hanami::Slice
    import keys: ["process_feed"], from: :feeds
  end
end
```

Now the feeds processor is available within the admin slice:

```ruby
Admin::Slice["feeds.process_feed"] # => #<Feeds::ProcessFeed>

# or as a dep:
module Admin
  class SomeClass
    include Deps["feeds.process_feed"]
  end
end
```

Slices can also be mounted within the router:

```ruby
module Bookshelf
  class Routes < Hanami::Routes
    slice :admin, at: "/admin" do
      get "/books" to: "books.index"
    end
  end
end
```

Slices can also be selectively loaded at boot time, which brings great advantages for ensuring best performance of certain production workloads. If you had a process working a Sidekiq queue for jobs from the feeds slice only, then you can set `HANAMI_SLICES=feeds` to load that slice only, giving you code isolation and optimal memory and boot time performance for that process.

Working with slices helps you maintain a clear understanding of the relationship between your app’s high-level concerns, just like how the Deps helps with this for individual components. Slices are the key to helping your app be just as easy to maintain at day 1,000 as it was at day 1.

✂️✂️✂️

## Faster

We’ve completely rewritten the HTTP router’s engine, with benchmarks showing it [outperforms nearly all others](https://hanamirb.org/blog/2020/02/26/introducing-hanami-api/).

You will see actions served in **microseconds**:

```
[bookshelf] [INFO] [2022-11-22 09:48:41 +0100] GET 200 129µs 127.0.0.1 / -
```

During the development, **the app will boot and reload instantly** due to a combination of lazy loading and autoloading of the code.

**No need to wait anymore** to use CLI commands.

But that isn't all: Hanami caches your application components (e.g. actions, try with `Hanami.app["actions.home.index"]`) when they are loaded.
The same cached component is used over and over for each incoming request, resulting in **a huge save in memory consumption**.

## Stronger

This release is **a triumph of indie development.**

After years of effort, our small group of volunteer developers has pulled it off! We also joined forces with the [dry-rb][dry-rb] team to rebuild Hanami on top of and around the dry-rb libraries. If you’ve ever had a passing interest in dry-rb, with Hanami 2.0 we’ve put together a curated experience and your easiest possible onramp.

Hanami 2.0 marks a **major moment for Ruby ecosystem diversity.** We’re providing a compelling and distinct new vision for Ruby apps, and with this release backed by a compassionate and dedicated core team, you can feel confident Hanami will be here for the long run.

Why don’t you take a look? We’d love for you to join us!

You're just a few commands away to build **better, faster, stronger apps**:

```shell
$ gem install hanami
$ hanami new bookshelf
$ cd bookshelf
$ bundle exec hanami server
```

[dry-rb]: https://dry-rb.org/

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
