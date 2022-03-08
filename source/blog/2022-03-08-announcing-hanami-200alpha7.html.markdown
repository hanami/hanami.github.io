---
title: Announcing Hanami v2.0.0.alpha7
date: 2022-03-08 12:00:00 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  Concrete slice classes, consistent action and view class structures
---

Hi again, Hanami friends, we’re happy to be back this month to share the release of Hanami 2.0.0.alpha7.

Before we go further, we want to make it clear that **we stand with the people of Ukraine in the face of the senseless, horrific attacks on their homeland by the Russian military.**

We stand with all victims of this war: all the people who didn’t want this war, but are now directly or indirectly impacted. People who have lost their lives, their friends, their hopes. People who have had to escape their country because there is no future left for them. **We stand for people, not for flags.**

If you can, [**please donate to support Ukrainians in this time of need**](https://razomforukraine.org).

At very least, take the time to [read this perspective](https://zverok.space/blog/2022-03-03-WAR.html) from our Ruby friend Victor “zverok” Shepelev, who is currently sheltering in the heavily bombarded Kharkiv, Ukraine, with his family. Victor should be spreading his Ruby magic, not dodging missiles.

As for this Hanami alpha release: it contains improvements to slice configuration, as well as the action and view class structure within generated applications.

## Slice configuration via concrete classes

You can now configure your slices by creating concrete classes for each slice in `config/slices/`:

```ruby
# config/slices/main.rb:

module Main
  class Slice < Hanami::Slice
    # slice config here
  end
end
```

The application-level `config.slice(slice_name, &block)` setting has been removed in favour of these classes, which provide much a clearer place for configuration.

As of this release, you can use the slice classes to configure your slice imports:

```ruby
# config/slices/main.rb:

module Main
  class Slice < Hanami::Slice
    # Import all exported components from "search" slice
    import from: :search
  end
end
```

As well as particular components to export:

```ruby
# config/slices/search.rb:

module Search
  class Slice < Hanami::Slice
    # Export the "index_entity" component only
    export ["index_entity"]
  end
end
```

Hanami slices use dry-system to manage their internal container of components. Hanami does all the work to configure this container to work according to framework conventions as well as your own specific application configuration. However, for advanced cases, you can also directly configure the slice’s container using `prepare_container` on the slice class:

```ruby
# config/slices/search.rb:

module Search
  class Slice < Hanami::Slice
    prepare_container do |container|
      # `container` (a Dry::System::Container subclass) is available here with
      # slice-specific configuration already applied
    end
  end
end
```

Finally, for simple Hanami applications, you don’t need to worry about creating these classes yourself: the framework will generate them for you in the absence of matching files in `config/slices/`.

## Application shutdown completeness

`Hanami::Application` provides a three-stage boot lifecycle, consisting of `.prepare`, `.boot`, and `.shutdown` methods, with the latter two steps calling `start` and `stop` respectively on each of the application’s registered providers.

As of this release, `Hanami::Slice` also exposes its own `.shutdown` method, and `Hanami::Application.shutdown` will also call `.shutdown` on all the registered slices.

## Consistent action and view class structure

As of this release we’ve settled upon a consistent structure for the action and view classes within generated applications.

For actions, for example, the following classes will be generated:

- A single application-level base class, e.g. `MyApp::Action::Base` in `lib/my_app/action/base.rb`. This is where you would put any logic or configuration that should apply to every action across all slices within the application.
- A base class for each slice, e.g. `Main::Action::Base` in `slices/main/lib/action/base.rb`, inheriting from the application-level base class. This is where you would put anything that should apply to all the actions only in the particular slice.
- Every individual action class would then go into the `actions/` directory within the slice, e.g. `Main::Actions::Articles::Index` in `slices/main/actions/articles/index.rb`.

For views, the structure is much the same, with `MyApp::View::Base` and `Main::View::Base` classes located within an identical structure.

The rationale for this structure is that it provides a clear place for any code to live that serves as supporting “infrastructure” for your application’s actions and views: it can go right alongside those `Base` classes, in their own directories, clearly separated from the rest of your concrete actions and views.

This isn’t an imagined requirement: in a standard Hanami 2 application, we’ll already be generating additional classes for the view layer, such as a view context class (e.g. `Main::View::Context`) and a base view part class (e.g. `Main::View::Part`).

This structure is intended to serve as a hint that your own application-level action and view behavior can and should be composed of their own single-responsibility classes as much as possible.

To put it all together, the following represents the expected structure in generated applications:

```
lib/
  app_template/
    action/
      base.rb                  # AppTemplate::Action::Base < Hanami::Action
    view/
      base.rb                  # AppTemplate::View::Base < Hanami::View
      context.rb               # AppTemplate::View::Context < Hanami::View::Context
      part.rb                  # AppTemplate::View::Part < Hanami::View::Part
slices/
  main/
    lib/
       action/
         base.rb               # Main::Action::Base < AppTemplate::Action::Base
         authentication.rb     # Main::Action::Authentication (EXAMPLE APP-SPECIFIC MODULE)
       view/
         base.rb               # Main::View::Base < AppTemplate::View::Base
         context.rb            # Main::View::Context < AppTemplate::View::Context
         part.rb               # Main::View::Part < AppTemplate::View::Part
         part_builder.rb       # Main::View::PartBuilder < Hanami::View::PartBuilder (OPTIONAL)
         helpers/
           authentication.rb   # Main::View::Helpers::Authentication (EXAMPLE APP-SPECIFIC MODULE)
         parts/
           article.rb          # Main::View::Parts::Article < Main::View::Part

    actions/                   # Concrete action classes (Main::Actions namespace)
    views/                     # Concrete view classes (Main::Views namespace)
```

Along with these changes, we’ve also streamlined the default view templates directory, changing it from `web/templates/` to just `templates/`.

## What’s included?

Today we’re releasing the following gems:

- `hanami` v2.0.0.alpha7
- `hanami-view` v2.0.0.alpha7

## Contributors

Thank you to these fine people for contributing to this release!

- [Luca Guidi](https://github.com/jodosha)
- [Tim Riley](https://github.com/timriley)
- [Sean Collins](https://github.com/cllns)

## How can I try it?

You can check out our [Hanami 2 application template](https://github.com/hanami/hanami-2-application-template), which is up to date with this latest release and ready for you to use as the starting point for your own app.

## What’s coming next?

We’re currently hard at work on porting our view helpers to Hanami 2, which we hope to share with you in some form next month.

Thank you as always for supporting Hanami!
