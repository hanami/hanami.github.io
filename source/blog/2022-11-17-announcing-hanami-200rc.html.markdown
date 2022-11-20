---
title: "Hanami 2.0: Awesome Short Summary Here"
date: 2022-11-17 08:24:53 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  TODO blah blah
---

After more than three years of work, Hanami 2.0 is here! This release marks a new era for Hanami, and presents a revolutionary new vision for Ruby applications!

## What is Hanami, and why does 2.0 matter?

Since our beginning we’ve called Hanami a _modern web framework for Ruby_. With today’s release, it becomes so much more. Hanami 2.0 is **the framework for Ruby apps of all shapes and sizes.**

With Hanami 2.0 you can still have your “hello world” app running within minutes, but you’ll be doing so using a framework that provides everything you need for your app to grow without sacrificing maintainability. With its innovative component management, Deps mixin and slices, Hanami is the first Ruby framework to acknowledge the **critical need to organise your business logic**, and ship with all the tools necessary to do so.

The majority of the code you’ll write in an Hanami app will be glorious plain old Ruby. **This is a framework that works in service of your code, rather than the other way around.** Hanami’s own facilities, such as the router and actions, are designed to occupy their own distinct layers that decorate and call into your code.

**Hanami will help you level up as a Rubyist.** From the very beginning it encourages you to consider separation of concerns, dependencies, and layered applications, and through its own classes, gives you working examples to follow. If you’ve ever felt dissatisfied with how your Ruby apps have turned out, Hanami is for you! It will give you a new lens on Ruby.

With 2.0, Hanami apps are no longer just for the web: Hanami is now **the everything framework for Rubyists.** Remove a few lines from your `Gemfile` and you can have everything you need and nothing you don’t. Remove the router and controller, for example, and you can build a chatbot or a Kafka consumer and still take advantage of all the other conveniences the framework provides.

This release is **a triumph of indie development.** To build Hanami 2.0, we teamed up with the [dry-rb][dry-rb] and rebuilt the framework on top of and around the dry-rb libraries. If you’ve ever had a passing interest in dry-rb, with Hanami 2.0 we’ve spent years putting together a curated experience and easiest possible onramp. It’s time to give it another look!

Hanami 2.0 also marks a **major moment for Ruby ecosystem diversity.** We’re providing a compelling and distinct new vision for Ruby apps, and with this release backed by a thoughtful and dedicated core team, you can feel confident Hanami will be here for the long run.

We’d love for you to join as and usher in a new breed of Ruby apps!

[dry-rb]: https://dry-rb.org/

## What’s new with 2.0?

Hanami 2.0 is jam packed with goodies:

- An **advanced new application core** offering advanced code loading capabilities
- An **always-there dependencies mixin**, helping you draw clearer connections between your app's components
- A **blazing fast new router**
- **Redesigned action classes** that integrate seamlessly with your app's business logic
- **Type-safe app settings** with dotenv integration, ensuring your app has everything it needs in every environment
- New **providers** for flexibly managing the lifecycle of your app's critical components and integrations
- New built-in **slices** for gradual modularisation as your app grows
- A **rewritten getting started guide** to help you get going with all of the above

### Advanced application core

At the heart of every Hanami 2.0 app is an advanced code loading system. It all begins when you run `hanami new` and have your app defined in `config/app.rb`:

```ruby
require "hanami"

module Bookshelf
  class App < Hanami::App
  end
end
```

From here you can build your app's logic in `app/`, and then boot the app, which loads all your code, as part of running a web server. This is the usual story.

In Hanami 2.0, your app can do so much more. You can use the app object itself to load and return any individual component:

```ruby
# Return an instance of the action in app/actions/home/show.rb

Hanami.app["actions.home.show"] # => #<Bookshelf::Actions::Home::Show>
```

You can also choose to _prepare_ rather than fully boot your app. This loads the minimal set of files required for your app to load individual components on demand. This is how the Hanami console launches, and how your app is prepared for running unit tests.

This means your experience interacting with your app remains as snappy as possible even as it grows to many hundreds or thousands of components. Your hanami console will always load in milliseconds, and your unit tests will keep you squarely in the TDD flow.

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

  let(:email_client) { spy(:email_client) }

  it "delivers the email" do
    daily_update.deliver("jane@example.com")

    expect(email_client)
      .to have_received(:send_email)
      .with(hash_including(to: "jane@example.com"))
  end
end
```

You can specify as many dependencies as you need to the Deps mixin. With it taking pride of place at the top of each class, it will help you as quickly identify exactly how each object fits within the graph of your app's components.

something something also helps you separate deps from other arguments?

The Deps mixin makes object composition natural and low-friction, making it easy for you to break down unwieldy classes. Before long you’ll be creating better single-responsibility and reusable components, easier to test and easier to understand. Once you get started, you’ll never want to go back!

### Blazing fast new router

Any web app needs a way to let users in, and Hanami 2.0 offers a friendly, intuitive routing DSL. You can add your routes to `config/routes.rb`:

```ruby
module Bookshelf
  class Routes < Hanami::Routes
    root to: "home.show"

    get "/books", to: "books.index"
    get "/books/:slug", to: "books.show"
    post "/books/:slug/reviews", to: "books.comments.create"
  end
end
```

We’ve completely rewritten the router’s engine, with benchmarks showing it [outperforms nearly all others](https://hanamirb.org/blog/2020/02/26/introducing-hanami-api/).

### Redesigned action classes

From routes we move to actions, the classes for handling individual HTTP endpoints. In Hanami 2.0 we’ve redesigned actions to fit seamlessly with the rest of your app.

In your actions you can now `include Deps` like any other class, which makes it to keep your business logic separate and your actions focused on HTTP interactions only:

```ruby
module Bookshelf
  module Actions
    module Books
      class Show < Bookshelf::Action
        include Deps["book_repo"]

        params do
          required(:slug).value(:string)
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

Hanami also loads your settings early in app boot and will raise an error for any settings that fail to meet their type expectations, giving you early feedback and ensuring your app doesn’t boot in a potentially invalid state.

[dotenv]: https://github.com/bkeepers/dotenv

### Providers

So far we’ve seen how your classes and settings can be accessed as components in your app. But what about components that require special handling to initialize? For these, Hanami 2.0 introduces providers. Here’s one for the `"email_client"` component we used earlier, in `config/providers/email_client.rb`:

```ruby
Hanami.app.register_provider :email_client do
  prepare do
    require "acme_email/client"
  end

  start do
    client = AcmeEmail::Client.new(
      api_key: target["settings"].email_client_api_key,
      default_from: "no-reply@bookshelf.example.com"
    )

    register "email_client", client
  end
end
```

Every provider has its own set of `prepare`/`start`/`stop` lifecycle steps, which is useful for setting up and using heavyweight components, or components that use tangible resources like database connections.

### Slices

As your app grows up, you may want to draw clear boundaries between its major areas of concern. For this, Hanami 2.0 introduces slices, a built-in facility for organising your code, encouraging maintainable boundaries, and creating operational flexibility.

To get started with a slice, create a directory under `slices/` and then start adding your code there, using a matching Ruby namespace. It’s that simple! Here’s a class that imports books for our bookshelf app:

```ruby
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

Every slice imports some basic components from the app, like the `"settings"`, `"logger"` and `"inflector"`, and slices can also be configued to import components from each other. If we added an admin slice to our app, we could make it possible for it run feed processing by specifying an import in the slice class at `config/slices/admin.rb`:

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

## Getting started with Hanami 2.0

Hopefully by now you’re excited to give Hanami 2.0 a try! To help you on your way, we’ve completely rewritten our friendly [user guides][guides] to cover all the important concepts for this new release.

A huge thank you to [Andrew Croome][andrew] and [Seb Wilgosz][seb] for delivering these guides!

[guides]: https://guides.hanamirb.org/v2.0/introduction/getting-started/
[andrew]: http://github.com/andrewcroome
[seb]: https://github.com/swilgosz

## What’s included?

Today’s release includes the following gems:

- hanami v2.0.0
- hanami-cli v2.0.0
- hanami-controller v2.0.0
- hanami-router v2.0.0
- hanami-validations v2.0.0
- hanami-utils v2.0.0
- hanami-reloader v2.0.0
- hanami-rspec v2.0.0

For specific changes, please see each gem’s own CHANGELOG and FEATURES files.

## How can I try it?

```shell
$ gem install hanami --pre
$ hanami new bookshelf
$ cd bookshelf
$ bundle exec hanami --help
```

## What’s next

For this release, we’ve focused on developing a powerful, polished framework core along with all the tools you need to deliver great web APIs. We hope you enjoy it!

From here we’re going to focus on finishing the rest of the “full stack” Hanami experience. This will include database integration, views, helpers and front end assets. We’re committed to delivering these within the first quarter of 2023.

## Contributors

Hanami 2.0 is brought to you by the core team of [Luca Guidi](https://github.com/jodosha), [Peter Solnica](https://github.com/solnic) and [Tim Riley](https://github.com/timriley).

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

## Thank you

Thank you so much for your support over the years as we built Hanami 2.0! It’s been a long journey, and we’re absolutely delighted (and only just a little bit tired) to be sharing this major new release with you!

We can’t wait to hear how you use it, and we’re looking forward to being back again to share the rest of our vision with you! 🌸
