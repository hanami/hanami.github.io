---
title: Guides - Selectively boot apps
version: 1.3
---

# Selectively boot apps

With Hanami you can build your project by following the [Monolith-First](guides/1.3/architecture/overview/#monolith-first) principle.
As you add more code to the project, you can grow it organically, by splitting the project into several Hanami apps.

A real world Hanami project could have **dozens of Hanami apps in the same project** (for example, `web` for the front-end, `admin` for the administration, `api` for a JSON API, etc...)
You might want to deploy them to different servers, even though they're all a part of the same project.
For example, most of the servers could be used for the `web` app (for customers on the site), a couple could be used for an `api` (perhaps for customers using mobile apps), and you could have a single server running and `admin` application, since it'll likely get less traffic than the other two.

We support this, with _selective booting_:

```ruby
# config/environment.rb
# ...
Hanami.configure do
  if Hanami.app?(:web)
    require_relative '../apps/web/application'
    mount Web::Application, at: '/'
  end

  if Hanami.app?(:api)
    require_relative '../apps/api/application'
    mount Api::Application, at: '/api'
  end

  if Hanami.app?(:admin)
    require_relative '../apps/admin/application'
    mount Admin::Application, at: '/admin'
  end
end
```

You can declare which apps to use with the `HANAMI_APPS` environment variable.
You can provide a single app, or several apps (joined with commas):

```shell
% HANAMI_APPS=web,api bundle exec hanami server
```

This would start only the `web` and `api` applications.
