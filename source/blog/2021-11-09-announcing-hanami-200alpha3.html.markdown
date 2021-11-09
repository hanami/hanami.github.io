---
title: Announcing Hanami v2.0.0.alpha3
date: 2021-11-09 12:30:00 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  Streamlined source directories, more flexible settings, better integrated actions, and the beginning of a monthly release cadence.
---

Hello Hanami community! It’s Tim here again, and I’m delighted to announce the release of Hanami 2.0.0.alpha3!

This release represents months of work on several foundational aspects of the framework, and brings:

- Streamlined source directories for easier-to-navigate project file trees
- Reworked application settings, leveraging a regular Ruby class to give you full flexibility with your setting definitions
- Reworked application routes, to match the above
- Improvements to view rendering within actions
- Framework settings ported to dry-configurable

## Streamlined source directories

In our previous alpha release, we required you to structure your source files in a way that matched the typical Ruby conventions for loading from the `$LOAD_PATH`. So if you had a `main` slice, and a `Main::MyClass` component, it would need to be located at `slices/main/lib/main/my_class.rb`. This worked well enough, but it presented awkwardly deep directory trees with redundant names, especially given we expect all components defined within each slice to live within its own singular namespace anyway. This latter aspect was already made clear by the fact that we removed that redundant leading "main" from the component’s key, with it available from the slice as `Main::Slice["my_class"]`.

So for this release, we made a major overhaul to our code loading to support our ideal source directory structure. Now in your `main` slice, your `Main::MyClass` component can be defined directly within it’s `lib/` directory, at `slices/main/lib/my_class.rb`, while still available from the slice as `Main::Slice["my_class"]`. This means one fewer directory to hop through, one less name to say when you’re communicating your source paths, and a much stronger signal that each slice should fully inhabit its own namespace.

Along with this, we’ve created a new facility to support special categories of components to be kept in their own top-level directories. For this release, this is determined by `Hanami.application.config.component_dir_paths`, which defaults to `["actions", "repositories", "views"]`. This allows you to define an action like `Main::Actions::Posts::Index` in its own special directory, at `slices/main/lib/actions/posts/index.rb`, with the component accessible from the slice as `Main::Slice["actions.posts.index"]`.

Together, these two changes should make finding and navigating both your slice’s business logic and its top-level entry points much easier.

Given these changes rely heavily on our configured [Zeitwerk](https://github.com/fxn/zeitwerk) autoloader, we’ve decided to make the autoloader an always-on feature for Hanami 2. While we strive to make most things as configurable as possible behind the scenes, we now consider the autoloader a foundational pillar for the Hanami 2 experience.

## Clarified application code loading

Along with the changes to code loading within slices, we’ve also updated the code loading strategy at the application level, for all the source files in your top-level `lib/` directory. As of this release, classes inside this directory will (unlike the slices) no longer auto-register as components. If you wish to register a component with the application, you should create a file in `config/boot/` like [the examples](https://github.com/hanami/hanami-2-application-template/blob/3ba7724a75272b61d52d628bdbbb6f90416645dc/config/boot/assets.rb) in our current application template.

The idea with this change is to help ensure you minimize the coupling across the application overall. Components within the application are automatically imported into all slices (e.g. with the `Hanami.application["logger"]` also available as `Main::Slice["application.logger"]`), so the fewer application-wide components you carry, the better. In addition, Hanami gives you another option for more intentional sharing of behavior: more slices! If there’s a distinct subset of related components that you want to make accessible to numerous other slices, you should define them within their own slice, and import that wherever needed. You can currently achieve this like so (and we’ll be working to make it more ergonomic in future releases):

```ruby
module MyApp
  class Application < Hanami::Application
    config.slice :main do
      # Importing a common "search" slice into the main slice; all components from the search
      # slice will be accessible with keys prefixed by "search."
      import :search
    end
  end
end
```

While we’re encouraging you to look to additional slices for sharing components, we still want to make it straightforward to share and access other aspects of common behavior across your application. To this end, we’ve clarified the autoloading rules for `lib/`: now, every file under the application’s namespace (such as `lib/my_app/my_class.rb`) will be autoloaded and available without explicit requires, to ensure the experience is consistent across both the application and slice namespaces.

All files in `lib/` outside the application namespace (such as `lib/some/other/class.rb`) will _not_ be autoloaded, and will need a `require` just like working with regular Ruby gems. This gives you a place to build out non-core, complementary code in your application without it being interfered with by the autoloader.

## Reworked application settings

As of this release, your application settings are now no longer defined within an anonymous block, and are instead delivered as a concrete class, still defined in `config/settings.rb`:

```ruby
require "hanami/application/settings"

module MyApp
  class Settings < Hanami::Application::Settings
    setting :my_secret
  end
end
```

The benefit these living within a class is that it gives us a place to hang all sorts of regular Ruby code to enhance the settings loading and delivery. For instance, it’s now possible to define an inline types module with [dry-types](https://dry-rb.org/gems/dry-types), to provide an expressive types library for validating and coercing your settings:

```ruby
require "dry/types"
require "hanami/application/settings"

module MyApp
  class Settings < Hanami::Application::Settings
    Types = Dry.Types()

    setting :my_secret, constructor: Types::String.constrained(min_size: 20)
  end
end
```

And since the settings are based on [dry-configurable](https://dry-rb.org/gems/dry-configurable), you can now easily provide default values, too:

```ruby
setting :my_bool, constructor: Types::Params::Bool, default: false
```

And finally, with a class at your disposal, you can also add your own methods to provide the best and most fit for purpose interface to your application settings:

```ruby
require "dry/types"
require "hanami/application/settings"

module MyApp
  class Settings < Hanami::Application::Settings
    Types = Dry.Types()

    setting :some_account_key, constructor: Types::String.optional

    def some_account_enabled?
      !!some_account_key
    end
  end
end
```

## Reworked application routes

We’ve also reworked the application routes to match the approach we’ve taken for the settings. As of this release, your `config/routes.rb` will no look something like this:

```ruby
require "hanami/application/routes"

module MyApp
  class Routes < Hanami::Application::Routes
    define do
      slice :main, at: "/" do
        root to: "home.show"
      end
    end
  end
end
```

For now, switching from the anonymous block to the concrete class is the extent of the change, but we expect this will provide a useful hook for your own custom behavior in the future, too. Watch this space.

## Various quality of life improvements to actions

We have a small assortment of small but improvements to actions for this release:

- Session behavior within actions is now automatically included whenever sessions are enabled via your application-level settings.
- Automatic view rendering how now been moved out of the default implementation of `Hanami::Action#handle` method, which is the where we expect you to put your own custom logic. With this change, you’ll no longer need to call `super` if you want to keep the automatic view rendering behavior.
- All action exposures are now automatically passed to the view for rendering (and will be passed onto your template if you provide a same-named exposure in your view class)

## Framework settings ported to dry-configurable

This is a mostly internal change, but the framework settings defined in `Hanami::Configuration` and exposed as `Hanami.application.config` are now largely provided by [dry-configurable](https://dry-rb.org/gems/dry-configurable), which will has made them significantly easier to maintain, and will provide us with some better building blocks for more extensible settings in future.

## What’s included?

Today we’re releasing the following gems:

- `hanami` v2.0.0.alpha3
- `hanami-cli` v2.0.0.alpha3
- `hanami-view` v2.0.0.alpha3
- `hanami-controller` v2.0.0.alpha3
- `hanami-utils` v2.0.0.alpha3

(We’re not making a new hanami-router release, since it has had no changes, and if we can keep that up for another couple of months – more on that below – the alpha versions can all sync up, which would please me greatly!)

## How can I try it?

You can check out our [Hanami 2 application template](https://github.com/hanami/hanami-2-application-template), which is up to date for this latest release and ready for you to use out as the starting point for your own app.

We’d really love for you to give the tires a good kick for this release in this particular: the more real-world testing we can have of our code loading changes, the better!

## What’s coming next?

As of this alpha release, we believe we’ve now jumped the biggest hurdles in preparing the overall Hanami 2 structure. From this point forward, we’ll be making monthly alpha release, bringing together all the work from the month and making it easily accessible to you (along with high-level release notes like this on our blog). We’re excited to pick up the pace of development work and to round out the Hanami 2 vision with you along for the ride!

Thank you as ever for your support of Hanami! We can’t wait to hear from you about this release, and we’re looking forward to checking in with you again next month. 🙇🏻‍♂️🌸
