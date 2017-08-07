---
title: Guides - Views Overview
version: head
---

# Overview

A view is an object that's responsible for rendering a template.

In a full stack Hanami application, an incoming HTTP request goes through the [router](/guides/head/routing/overview), it instantiates and calls an [action](/guides/head/actions/overview), which sets the status code and the headers for the response.
The last bit is the body, which is set by the corresponding view's output.

## A Simple View

Hanami ships a generator for actions that creates a view and a template.

```shell
% hanami generate action web dashboard#index
    insert  apps/web/config/routes.rb
    create  spec/web/controllers/dashboard/index_spec.rb
    create  apps/web/controllers/dashboard/index.rb
    create  apps/web/views/dashboard/index.rb
    create  apps/web/templates/dashboard/index.html.erb
    create  spec/web/views/dashboard/index_spec.rb
```

Looking at those file names, we have an action called `Web::Controllers::Dashboard::Index` (read about [actions naming](/guides/head/actions/overview)).
Our view has a similar name: `Web::Views::Dashboard::Index`.

Let's examine the view:

```ruby
# apps/web/views/dashboard/index.rb
module Web::Views::Dashboard
  class Index
    include Web::View
  end
end
```

### Naming

That file begins with a module declaration which is similar to the [action naming structure](/guides/head/actions/overview).
The only difference is that we use `Views` module instead of `Controllers`.
**All the views are nested under it.**
This module is generated at the runtime for us, when the application starts.

<p class="convention">
  For a given application named <code>Web</code>, views are available under <code>Web::Views</code>.
</p>

**This symmetry is really important at run time.**
After the action has finished its job, control passes to the framework which looks for the matching view.

<p class="convention">
  For a given action named <code>Web::Controllers::Home::Index</code> which is handling a request, Hanami will look for a corresponding <code>Web::Views::Home::Index</code> view.
</p>

### View Module

All the main Hanami components are mixins meant to be included.
Because a Hanami Container can run multiple applications within the same Ruby process, the configurations of these different components should be kept separated.

In our example, we have a directive `include Web::View`.
That means our view will behave according to the configuration of the `Web` application.

<p class="convention">
  For a given application named <code>Web</code>, the view mixin to include is <code>Web::View</code>.
</p>
