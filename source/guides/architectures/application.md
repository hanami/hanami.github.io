---
title: "Hanami | Guides - Architectures: Application"
---

# Architectures

## Application

This is an alternative Hanami architecture that should be used only at the later stage of a project, when we have already considered extracting to microservices.

Hanami applies the [Monolith First](http://martinfowler.com/bliki/MonolithFirst.html) principle.
In the early days of our product, we are moving fast and it's more convenient to keep all the components in the same repository and in the same Ruby process.

This is possible with Hanami [Container architecture](/guides/architectures/container) and we **strongly** suggest using it for new projects.

Application architecture is suggested for small web components.

To be more precise, it can handle a large amount of code, and it has a structure that is similar to Ruby on Rails applications.
However, we want to offer a different approach, large projects should use different components (Container), instead of using the same component for everything.

### Anatomy Of An Application

Let's use the application generator to create a new Hanami app.

```shell
% hanami new admin --arch=app
```

We use the `--arch` CLI argument to specify that we want to use the Application architecture.

```shell
% tree -L 1
.
├── Gemfile
├── Rakefile
├── app
├── config
├── config.ru
├── db
├── lib
├── public
└── spec

6 directories, 3 files
```

We have almost all the directories that a [Container](/guides/architectures/container) project has, the only difference is `app/`.
While the other structure has an `apps/` directory, because it's designed to host more than one component, here we have only one.

That directory is minimal: it hosts just a default [layout](/guides/views/layouts) and the related template.

```shell
% tree app
app
├── controllers
├── templates
│   └── application.html.erb
└── views
    └── application_layout.rb
```

Our core application still lives in `lib/` because we still want to apply the [Clean Architecture](https://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html), but `application.rb` and `routes.rb` are placed under `config/`.

### Extract A Microservice

Imagine we have built a product named _Bookshelf_, that is an online place where customers share their opinions about their readings, and they are also able to purchase books within our app.

We have been running our business for three years now. During this time we moved fast to implement new features intended to make it more appealing to the market.

We went for the Container architecture, and now we have a few components such the admin pane, that were useful to keep in the same Ruby process, but now we want to move to a separated server.
Theoretically all we need to do is to move it from `apps/admin` into a different repository and deploy it separately.

However, there are some configuration files that we want to let Hanami generate for us.
