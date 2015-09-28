---
title: "Lotus - Guides - Command Line: Generators"
---

# Command Line

## Generators

Lotus has convenient code generators to speed up our development process.

### Applications

With the Container architecture, we can have multiple Lotus applications running under `apps/`.
The default application is called `Web` and lives under `apps/web`.

We can generate new applications for different components that we want to add to our project.

```shell
% bundle exec lotus generate app admin
```

This generates an application named `Admin` under `apps/admin`.

### Actions

We can generate an action along with the corresponding view, template, route and test code with one command.

```shell
% bundle exec lotus generate action web books#show
```

The first argument, `web`, is the name of the target application in a Container architecture.
**It must be omitted if used within an Application architecture:**


```shell
% bundle exec lotus generate action books#show
```

The argument `books#show` is the name of the controller and the action separated by the number sign (`#`).

If you wish to generate only the action, without the view and template, you can do that by using the `--skip-view`.

```shell
% bundle exec lotus generate action web books#show --skip-view
```

#### Route

The generated route is named after the controller name.

```ruby
# apps/web/config/routes.rb
get '/books', to: 'books#show'
```

If we want to customize the route URL, without editing our routes file, we can specify a `--url` argument.

```shell
% bundle exec lotus generate action web books#show --url=/books/:id
```

This will generate the following route:

```ruby
# apps/web/config/routes.rb
get '/books/:id', to: 'books#show'
```

### Models

We can generate a model.

```shell
% bundle exec lotus generate model book
```

It generates an entity with the corresponding repository and test code.

### Migrations

We can generate a migration.

```shell
% bundle exec lotus generate migration create_books
```

It generates an empty migration with the UTC timestamp and the name we have specified: `db/migrations/20150621181347_create_books.rb`.

### Mailers

We can generate a mailer.

```shell
% bundle exec lotus generate mailer welcome
```

It creates the following files:

```shell
% tree lib/
lib
├── bookshelf
│   # ...
│   ├── mailers
│   │   ├── templates
│   │   │   ├── welcome.html.erb
│   │   │   └── welcome.txt.erb
│   │   └── welcome.rb # Mailers::Welcome
# ...
```
