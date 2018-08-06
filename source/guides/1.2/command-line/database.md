---
title: "Guides - Command Line: Database"
version: 1.2
---

# Database

We can manage our database via the command line.

**The following commands can be only used with the SQL adapter and with the following databases:**

  * PostgreSQL
  * MySQL
  * SQLite3

The [adapter](/guides/1.2/models/overview) is set in `config/environment.rb`.
It uses an environment variable, defined in the `.env.*` files at the root of the project.

## Create

With `db create` we can create the database for the current environment.

```shell
% bundle exec hanami db create
```

To be able to run tests, test database has to be explicitly created

```shell
% HANAMI_ENV=test bundle exec hanami db create
```

In order to preserve production data, this command can't be run in the production environment.

## Drop

With `db drop` we can drop the existing database for the current environment.

```shell
% bundle exec hanami db drop
```

In order to preserve production data, this command can't be run in the production environment.

## Migrate

With `db migrate` we can run [migrations](/guides/1.2/migrations/overview) found in `db/migrations`.

Given the following migrations:

```shell
% tree db/migrations
db/migrations
├── 20171024081558_create_authors.rb
├── 20171024081617_create_books.rb
├── 20171024083639_create_users.rb
├── 20171024083725_create_avatars.rb
├── 20171024085712_create_stories.rb
└── 20171024085858_create_comments.rb

0 directories, 6 files
```

We run `db migrate`, then the database _version_ becomes `20171024085858`, which is the maximum timestamp from the migrations above.

```shell
% bundle exec hanami db migrate # Migrates to max migration (20171024085858)
```

This command accepts an optional argument to specify the target version.
For instance, if we want to **get back to** the changes from `20171024083639_create_users.rb`, we can migrate _**"down"**_.

```shell
% bundle exec hanami db migrate 20171024083639 # Migrates (down) to 20171024083639
```

**This command is available in ALL the environments and ALL the SQL databases.**

## Rollback

Rollback the database to a number of _steps_ _**"down"**_.

We have the following migrations:

```shell
% tree db/migrations
db/migrations
├── 20171024081558_create_authors.rb
├── 20171024081617_create_books.rb
├── 20171024083639_create_users.rb
├── 20171024083725_create_avatars.rb
├── 20171024085712_create_stories.rb
└── 20171024085858_create_comments.rb

0 directories, 6 files
```

When we migrate the database:

```shell
% bundle exec hanami db migrate # Migrates to max migration (20171024085858)
```

We can rollback the last migration

```shell
% bundle exec hanami db rollback # Migrates (down) to 20171024085712
```

We can rollback the 3 migrations

```shell
% bundle exec hanami db rollback 3 # Migrates (down) to 20171024081617
```

## Prepare

Prepares database for the current environment. This command can't be run in the production environment.

When we run `db prepare` it:

  * Creates the database
  * Loads SQL dump (if any, see `db apply`)
  * Runs pending migrations

```shell
% bundle exec hanami db prepare
```

This command SHOULD be used as a database setup command.

## Apply

This is an experimental feature.
When an application is developed after years, it accumulates a large number of migrations, this slows down database operations for development and test (CI).

Because it does destructive changes to files under SCM, this is only allowed in development mode.

When we run `db apply`, it:

  * Runs pending migrations
  * Dumps a fresh schema into `db/schema.sql`
  * Deletes all the migrations from `db/migrations`

```shell
% bundle exec hanami db apply
```

This command is available only in the development environment.

## Version

Prints current database version. Given the following migrations:

```shell
% tree db/migrations
db/migrations
├── 20171024081558_create_authors.rb
├── 20171024081617_create_books.rb
├── 20171024083639_create_users.rb
├── 20171024083725_create_avatars.rb
├── 20171024085712_create_stories.rb
└── 20171024085858_create_comments.rb

0 directories, 6 files
```

When we migrate the database:

```shell
% bundle exec hanami db migrate
```

We can then ask for the current version:

```shell
% bundle exec hanami db version
20171024085858
```
