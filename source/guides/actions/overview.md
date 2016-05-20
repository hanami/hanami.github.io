---
title: Guides - Actions Overview
---

# Overview

An action is an endpoint that handles incoming HTTP requests for a specific [route](/guides/routing/overview).
In a Hanami application, an **action is an object**, while a **controller is a Ruby module** that groups them.

This design provides self contained actions that don't share their context accidentally with other actions.  It also prevents gigantic controllers.
It has several advantages in terms of testability and control of an action.

## A Simple Action

Hanami ships with a generator for actions. Let's create a new one:

```shell
hanami generate action web dashboard#index
```

Let's examine the action:

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    def call(params)
    end
  end
end
```

### Naming

That file begins with a module declaration.

The first token is the name of our application: `Web`.
Hanami can run multiple applications within the same Ruby process.
They are located under `apps/`.
Their name is used as a **top-level module to contain inner components** like actions and views, in order to **avoid naming collisions**.
If we have another action `Home::Index` under an application `Admin`, the two of them can coexist inside the same codebase.

The second token is a conventional name: `Controllers`.
**All the controllers are nested under it.**
This module is generated at runtime for us, when the application starts.

<p class="convention">
  For a given application named <code>Web</code>, controllers are available under <code>Web::Controllers</code>.
</p>

The last bit is `Dashboard`, which is our controller.

The whole action name is `Web::Controllers::Dashboard::Index`.

<p class="warning">
  You should avoid giving your action modules the same name as your application, e.g. avoid naminng a controller `Web` in an app named `Web`. If you have a controller name like `Web::Controllers::Web` then some code across your app will break with errors about constants not being found, for example in views which `include Web::Layout`. This is because Ruby starts constant lookup with the current module, so a constant like `Web::Layout` referenced by code in the `Web::Controllers::Web` or `Web::Controllers::Web::MyAction` module will be converted to `Web::Controllers::Web::Layout`, which can't be found and causes a constant lookup error.
</p>
<p class="warning">
  If you absolutely must name a controller with the same name as your application, you'll need to explicitly set the namespace lookup for things which should be included from immediately under the app, not the controller by prefixing those names with `::`, e.g. change your views to include `::Web::Layout` instead of `include Web::Layout`, and using `include ::Web::Action` in your controllers.
</p>

### Action Module

Hanami philosophy emphasizes _composition over inheritance_ and avoids the [framework superclass antipattern](http://michaelfeathers.typepad.com/michael_feathers_blog/2013/01/the-framework-superclass-anti-pattern.html).
For this reason, all the components are provided as **modules to include** instead of base classes to inherit from.

Like we said before, Hanami can run multiple apps within the same Ruby process.
Each of them has its own configuration.
To keep separated actions from an application named `Web` and an application named `Admin`, we include `Web::Action` and `Admin::Action` respectively.

In our example, we have a directive `include Web::Action`.
That means our action will behave according to the configuration of the `Web` application.

<p class="convention">
  For a given application named <code>Web</code>, the action mixin to include is <code>Web::Action</code>.
</p>

### Interface

When we include `Web::Action`, we made our object compliant with [Hanami::Controller](https://github.com/hanami/controller)'s actions.
We need to implement `#call`, which is a method that accepts only one argument: `params`.
That is the object that carries the payload that comes from incoming HTTP requests from the [router](/guides/routing/basic-usage).

This interface reminds us of Rack.
Indeed, our action is compatible with the Rack protocol.
