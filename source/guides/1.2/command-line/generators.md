---
title: "Guides - Command Line: Generators"
version: 1.2
---

# Generators

Hanami has convenient code generators to speed up our development process.

## Applications

With Hanami architecture, we can have multiple Hanami applications running under `apps/`.
The default application is called `Web` and lives under `apps/web`.

We can generate new applications for different components that we want to add to our project.

```shell
% bundle exec hanami generate app admin
```

This generates an application named `Admin` under `apps/admin`.

## Actions

Generate an action along with the corresponding view, template, route and test code with one command.

```shell
% bundle exec hanami generate action web books#show
```

The first argument, `web`, is the name of the target application in a Hanami project.

The argument `books#show` is the name of the controller and the action separated by the number sign (`#`).

If you wish to generate only the action, without the view and template, you can do that by using the `--skip-view`.

```shell
% bundle exec hanami generate action web books#show --skip-view
```

If you wish to generate action with specific method, you can do that by using the `--method`.

```shell
% bundle exec hanami generate action web books#create --method=post
```

### Route

The generated route is named after the controller name.

```ruby
# apps/web/config/routes.rb
get '/books', to: 'books#show'
```

If we want to customize the route URL, without editing our routes file, we can specify a `--url` argument.

```shell
% bundle exec hanami generate action web books#show --url=/books/:id
```

This will generate the following route:

```ruby
# apps/web/config/routes.rb
get '/books/:id', to: 'books#show'
```

The default HTTP method is `GET`, except for actions named:

- `create`, which will use `POST`
- `update`, which will use `PATCH`
- `destroy`, which will use `DELETE`

This should help you route using [RESTful resources](/guides/1.2/routing/restful-resources).

You can also set the HTTP method by specifying a `--method` argument when calling `hanami generate action`.

## Models

Generate an entity and a repository with a single command

```shell
% bundle exec hanami generate model book
      create  lib/bookshelf/entities/book.rb
      create  lib/bookshelf/repositories/book_repository.rb
      create  db/migrations/20170213123250_create_books.rb
      create  spec/bookshelf/entities/book_spec.rb
      create  spec/bookshelf/repositories/book_repository_spec.rb
```

It generates an entity with the corresponding repository, migration, and tests.

The migration will already contain the code for the creation of the table, the primary key and the timestamps:

```ruby
# db/migrations/20170213123250_create_books.rb
Hanami::Model.migration do
  change do
    create_table :books do
      primary_key :id

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
```

## Migrations

Generate a database migration

```shell
% bundle exec hanami generate migration create_books
      create  db/migrations/20161112113203_create_books.rb
```

It generates an empty migration with the UTC timestamp and the name we have specified: `db/migrations/20161112113203_create_books.rb`.

## Mailers

Generate a mailer

```shell
% bundle exec hanami generate mailer welcome
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

## Secret

Generate a HTTP sessions secret for an application.

```shell
% bundle exec hanami generate secret web
Set the following environment variable to provide the secret token:
WEB_SESSIONS_SECRET="a6aa65a71538a56faffe1b1c9e96c0dc600de5dd14172f03c35cc48c3b27affe"
```
