---
title: Announcing Hanami v2.0.0.alpha8
date: 2022-05-19 12:00:00 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  New base action and view classes, and a few fixes
---

After a month’s break, we’re back with another Hanami 2.0.0 alpha release for you all!

This release includes new base action and view classes, plus a few small fixes.

## New base action and view classes

This release includes new base classes for actions and views that integrate with their surrounding Hanami application: `Hanami::Application::Action`, `Hanami::Application::View`, and `Hanami::Application::View::Context`. Your base classes should now look like this:

```ruby
# lib/my_app/action/base.rb:

require "hanami/application/action"

module MyApp
  module Action
    class Base < Hanami::Application::Action
    end
  end
end
```

```ruby
# lib/my_app/view/base.rb:

require "hanami/application/view"

module MyApp
  module View
    class Base < Hanami::Application::View
    end
  end
end
```

```ruby
# lib/my_app/view/context.rb:

require "hanami/application/view/context"

module MyApp
  module View
    class Context < Hanami::Application::View::Context
    end
  end
end
```

Our current [application template](https://github.com/hanami/hanami-2-application-template) has been updated to use these new classes.

We’ve also relocated the code for these classes from hanami-controller and hanami-view into the hanami gem itself, which will help us maintain the best possible integrated experience as we work towards 2.0.0 and beyond.

Any supporting code for these integrated classes is conditionally loaded based on the presence of their counterpart gems (hanami-controller and hanami-view), so you can continue to pare back the framework to suit different needs by removing hanami-controller and/or hanami-view from your application’s `Gemfile`.

## A few small fixes

Thanks very much to our contributors, this release also includes a few small fixes:

- `hanami db` CLI commands work again
- Action classes with an already-halted response will no longer attempt to render their automatically paired view

## What’s included?

Today we’re releasing the following gems:

- `hanami` v2.0.0.alpha8
- `hanami-cli` v2.0.0.alpha8 (with a follow-up fix available in 2.0.0.alpha8.1)
- `hanami-controller` v2.0.0.alpha8
- `hanami-view` v2.0.0.alpha8

## Contributors

Thank you to these fine people for contributing to this release!

- [Andrew Croome](https://github.com/andrewcroome)
- [Lucas Mendelowski](https://github.com/lcmen)
- [Tim Riley](https://github.com/timriley)

## How can I try it?

You can check out our [Hanami 2 application template](https://github.com/hanami/hanami-2-application-template), which is up to date with this latest release and ready for you to use as the starting point for your own app.

## What’s coming next?

We’re still working away at porting our view helpers to Hanami 2, which we hope to share with you in some form next month.

Thank you as always for supporting Hanami!
