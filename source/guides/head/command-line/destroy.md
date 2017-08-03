---
title: "Guides - Command Line: Destroy"
version: head
---

# Command Line

## Destroy

Hanami has convenient [code generators](/guides/head/command-line/generators) to speed up our development process.
If we commit a mistake, we can destroy what we just generated via `hanami destroy` command.

### Applications

With the Container architecture, we can have multiple Hanami applications running under `apps/`.
We can [generate new applications](/guides/head/command-line/generators) for different components that we want to add to our project.

To destroy one of them:

```shell
% bundle exec hanami destroy app admin
```

This removes an application named `Admin` under `apps/admin`.

### Actions

We can destroy an action along with the corresponding view, template, route and test code with one command.

```shell
% bundle exec hanami destroy action web books#show
```

The first argument, `web`, is the name of the target application in a Container architecture.
**It must be omitted if used within an Application architecture:**

```shell
% bundle exec hanami destroy action books#show
```

The argument `books#show` is the name of the controller and the action separated by the number sign (`#`).

### Models

We can destroy a model.

```shell
% bundle exec hanami destroy model book
```

It removes an entity with the corresponding repository and test code.

### Migrations

We can destroy a migration.

```shell
% bundle exec hanami destroy migration create_books
```

It deletes the migration with the corresponding name (eg. `db/migrations/20150621181347_create_books.rb`).

### Mailers

We can destroy a mailer.

```shell
% bundle exec hanami destroy mailer welcome
```

It removes the mailer, and the associated templates.
