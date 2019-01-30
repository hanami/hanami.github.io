---
title: Announcing Hanami v2.0.0.alpha1
date: 2019-01-30 13:24:51 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  First preview of the 2.0 series. App simplification, new router, rewritten actions, fresh code reloading strategy.
---

Hello wonderful community! ❤️🌸

Today we're thrilled to announce `v2.0.0.alpha1` release 🙌.

## A fresh start 😎

Today's release is the beginning of Hanami 2 series. The final 2.0 version will be released later this year.

We decided to **start fresh** with the development of the framework.
The internals needed a cleanup because the code was accumulating techical debt from the old days of Lotus.
To evolve it would have required too much effort. Given 1.3 is 4k lines of code, it made a lot of sense for us to start from scratch.

That means this release is not meant to be comparable in terms of features with 1.3, but it's more a **preview** of Hanami 2.

## Application

### DRY-up settings

The big change from Hanami 1 is the removal of all the applications (`web`, `admin`) as a way to micro-configure areas of your project.

In the past we had:

  * `config/enviroment.rb`
  * `apps/{web,admin,...}/application.rb`

To configure where to load files from, which was the default response format for each single app, the sessions, cookies, base URL, just to name a few.

The concept is to **unify** all these settings at the level of `config/application.rb`, so they are **propagated** to the apps.
DRY at its finest.

Here's an example of  `config/application.rb`:

```ruby
# frozen_string_literal: true

module Soundeck
  class Application < Hanami::Application
    config.cookies  = { max_age: 600 }
    config.sessions = :cookie, { secret: ENV["SOUNDECK_SESSIONS_SECRET"] }
    config.middleware.use Middleware::Elapsed, "1.0"

    config.environment(:production) do |c|
      c.base_url = ENV["SOUNDECK_BASE_URL"]
      c.logger = { level: :info, formatter: :json }
    end
  end
end
```

## Configuration

We introduced a new syntax for the application configuration based on **getters** and **setters**, instead of the DSL we had in Hanami 1.

#### Before

```ruby
cookies max_age: 600
```

#### After

```ruby
config.cookies = { max_age: 600 }
```

This new syntax helps to simplify the internals, by explicitly separating the intent of reading a value from the intent of setting it.

`Hanami::Configuration` now performs **atomic/thread-safe operations** both at the read and write time.

### Defaults

Another difference from the past is that configuration now ships with **defaults**, **instead of making everything explicit** in the generated app.

Let me give you an example:

#### Before

This was an explicit setting of each application configuration.

```ruby
# apps/web/application.rb
security.x_frame_options = "DENY"
```

#### After

Now the configuration has that value as a default, so the generated code is **empty**:

```ruby
```

In case a developer needs to change the default, they will do it for the **whole app**:

```ruby
# config/application.rb
config.security.x_frame_options = "sameorigin"
```

## Router

`hanami-router` has been rewritten more than a year ago. It's more efficient (+10k req/s for simple Rack benchmark) and it's now based on `mustermann` path matchers, which powers Sinatra routing as well.

In Hanami 1 we had several places to configure the whole routes of an app: `apps/{web,admin,...}/config/routes.rb`.
Now these files are gone in favor of `config/routes.rb` at the root of the project.

This change has an impact both on **simplification and performance**.

Thanks to `hanami-router` 2, we can define all the routes for all the apps in **a single shot** in `config/routes.rb`:

```ruby
# frozen_string_literal: true

Hanami.application.routes do
  mount :web, at: "/" do
    root to: "home#index"
  end

  mount :admin, at: "/admin" do
    root to: "home#index"
  end
end
```

Please note the differences from the past:

  * No more multiple files and multiple routers instances for multiple apps
  * Single router for the whole app 🙌 
  * Mounting apps is no longer delegated to the gone `Hanami.configure`, which was cluttering `config/environment.rb`
  * Apps as concrete classes are gone (e.g. `Web::Application`), in favor of symbols
  * The apps registered with `mount` are the ones that are activated in the internal container

## Actions

Actions are been redesigned to improve their performance.
In Hanami 1, for each incoming HTTP request, we had to create a new action instance, because assigning instance variables (e.g. `@book`) and using them as exposures, we had to re-create a blank state, with a new action.
In the long run, that was putting pressure on Ruby _garbage collector_.

To remediate to this problem, we made the actions **immutable**.
In order to pass the data from the action to the view, you can use:

```ruby
response[:book] = Book.new
```

This also eliminates the need to declare data via the `expose` DSL, which is now gone.

Another important change from the past is that `Hanami::Action` is now a **superclass** to inherit from.
In your app you will have a base action class for each sub application (e.g. `apps/web/action.rb`):

```ruby
# frozen_string_literal: true

module Web
  class Action < Hanami::Action
  end
end
```

This base class is designed to share code with its subclasses.
For instance, the action at `apps/web/actions/books/show.rb` will look like this:

```ruby
# frozen_string_literal: true

module Web
  module Actions
    module Books
      class Show < Web::Action
        def handle(req, res)
          res[:book] = BookRepository.new.find(req.params[:id])
        end
      end
    end
  end
end
```

## Code reloading

We extracted code reloading from `hanami` core to `hanami-reloader`.

The new implementation is based on `guard-rack`: this gem watches the file system and restarts the server when it detects a file change.
This makes code reloading an external feature of the framework, no longer builtin in its core.
The previous builtin implementation based on `shotgun` was causing compatibility problems (JRuby, Windows, `better_errors` gem), and it was source of bugs.

The feature is still integrated with `hanami server` (use `--no-code-reloading` to skip).
The interesting bit is that, if `hanami-reloader` isn't installed, `hanami server` won't use code reloading, because it isn't implemented by Hanami.
This is useful in production, where you don't need code reloading.

## CLI commands

Because this is the first preview of 2.0, only two CLI commands are available for now:

  * `hanami version`
  * `hanami server`

We'll re-add all the usual CLI commands from 1.3, as soon we'll implement the related features.

## Released Gems 💎

  * `hanami-2.0.0.alpha1`
  * `hanami-cli-1.0.0.alpha1`
  * `hamami-controller-2.0.0.alpha1`
  * `hanami-router-2.0.0.alpha1`
  * `hanami-utils-2.0.0.alpha1`
  * `hanami-reloader-1.0.0.alpha1`

## How to try it ⌨️

```shell
$ gem install hanami --pre
```

Please check out [https://github.com/jodosha/soundeck](https://github.com/jodosha/soundeck) if you want to see a working example.

## What's next? ⏰

We'll release a new alpha version, in **April 2019**.

Happy coding! 🌸
