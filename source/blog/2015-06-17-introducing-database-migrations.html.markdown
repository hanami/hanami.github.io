---
title: Introducing Database Migrations
date: 2015-06-17 14:34 UTC
tags: features
author: Luca Guidi
excerpt: >
  New feature for the upcoming v0.4.0: database migrations. Fast operations for schema: create, drop, migrate and prepare database. Keep migrations healthy with experimental feature.
---

## Introduction

Lotus v0.4.0 (Jun 23) will ship a really useful feature: database migrations.

It's a really fast way to manage database schema via Ruby.
For a detailed explanation of the feature, please have a look at the related [pull](https://github.com/lotus/model/pull/196) [requests](https://github.com/lotus/lotus/pull/256).

## Command Line

Here's new CLI facilities to control database schema.

```shell
% lotus new bookshelf --database=postgres && cd bookshelf && bundle
% lotus db
Commands:
  lotus db apply           # migrate, dump schema, delete migrations (experimental)
  lotus db console         # start DB console
  lotus db create          # create database for current environment
  lotus db drop            # drop database for current environment
  lotus db help [COMMAND]  # Describe subcommands or one specific subcommand
  lotus db migrate         # migrate database for current environment
  lotus db prepare         # create and migrate database
  lotus db version         # current database version
```

These commands modify the database for the current environnment.
There are some **safety mechanisms**, for instance `db drop` will raise an error if ran in production mode.

### Migration Generator

This upcoming version will ship with a migration generator.

```shell
% lotus generate migration create_users
    create  db/migrations/20150617145519_create_books.rb
```

Let's edit it:

```ruby
Lotus::Model.migration do
  change do
    create_table :books do
      primary_key :id
      foreign_key :author_id, :authors, on_delete: :cascade, null: false

      column :code,  String,  null: false, unique: true, size: 128
      column :title, String,  null: false
      column :price, Integer, null: false, default: 100 # cents

      check { price > 0 }
    end
  end
end
```

We use a `create_table` block to define the schema of that table.

The first line is `primary_key :id`, which is a shortcut to create an autoincrement integer column.

There is a foreign key definition with cascade deletion.
The first argument is the name of the local column (`books.author_id`), while the second is the referenced table.

Then we have three lines for columns.
The first argument that we pass to `#column` is the name, then the type.
The type can be a **Ruby type** such as `String` or `Integer` or a string that represent the **native database type** (eg. `"varchar(32)"` or `"text[]"`).

As a last optional argument there is a Hash that specify some extra details for the column. For instance NULL or uniqueness constraints, the size (for strings) or the default value.

The final line defines a database **check** to ensure that price will always be greater than zero.

### Migrate

As first thing we need to create the database and then we can modify the schema.

```shell
% lotus db create
% lotus db migrate
```

When we run `db migrate`, it applies all the pending migrations under `db/migrations`.
Our `books` table is now created. We can ask our application what's the current schema version.


```shell
% lotus db version
20150617145519
```

In case we want to target a specific database version, we can pass it as extra argument to `db migrate`.
This is useful if we want to partially migrate the database, or rollback some changes.

For instance, if we recognize an error in our just created migration, we can do:

```shell
% lotus db migrate 0 # get back to the initial version
% vim db/migrations/20150617145519_create_books.rb
% lotus db migrate # run all the pending migrations again
```

### Prepare

We're fan of system automations, for this reason we have added a new command to get our database ready for development, tests or CI: `db prepare`.

It performs the following operations:

  * Creates database
  * Load schema structure, if present (see next section, _Apply_).
  * Runs pending migrations

If used with `db apply` it's **really fast** and it should be the **preferred way** to setup databases.

### Apply

When an application is developed for years, it accumulates dozens or hundreds of migrations.
This slows down database operations for development and tests (CI).

We have introduced an **experimental feature**: `db apply`.
By running this command, it:

  * Runs pending migrations
  * Dumps schema informations into `db/schema.sql`
  * Deletes all the migrations from `db/migrations`

```shell
% lotus db apply
% tree db/migrations

0 directories, 0 files
```

## Release Date

Database migrations will be available with `lotusrb-0.4.0`, expected for **June 23, 2015**.

<div style="display: inline">
  <iframe src="https://ghbtns.com/github-btn.html?user=lotus&repo=lotus&type=star&count=true&size=large" frameborder="0" scrolling="0" width="160px" height="30px"></iframe>
</div>
