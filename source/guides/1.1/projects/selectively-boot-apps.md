---
title: Guides - Selectively boot apps
version: 1.1
---

# Selectively boot apps

With Hanami you can build your project by following the [Monolith-First](/guides/1.1/architecture/overview/#monolith-first) principle.
You add more and more code to the project, but growing it organically, by using several Hanami apps.

There are cases of real world products using a **dozen of Hanami apps in the same project** (eg `web` for the frontend, `admin` for the administration, etc..)
They deploy the project on several servers, by booting only a subset of these apps.
So the servers A, B, and C are for customers (`web` application), D is for administration (`admin` application), while E, and F are for API (`api` application)

To serve this purpose we introduced _selective booting_ feature.


```ruby
# config/environment.rb
# ...
Hanami.configure do
  if Hanami.app?(:api)
    require_relative '../apps/api/application'
    mount Api::Application, at: '/api'
  end

  if Hanami.app?(:admin)
    require_relative '../apps/admin/application'
    mount Api::Application, at: '/admin'
  end

  if Hanami.app?(:web)
    require_relative '../apps/web/application'
    mount Api::Application, at: '/'
  end
end
```

Then from the CLI, you use the `HANAMI_APPS` env var.

```shell
$ HANAMI_APPS=web,api bundle exec hanami server
```

With the command above we start only `web` and `api` applications.
