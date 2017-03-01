---
title: Announcing Hanami v1.0.0.beta1
date: 2017-02-14 13:33 UTC
tags: announcements
author: Luca Guidi & Oana Sipos
image: true
excerpt: >
  Feature freeze, project logger, automatic logging of requests, SQL queries, and migrations. Minor bug fixes.
---

This `v1.0.0.beta1` release marks Hanami's [feature freeze](https://en.wikipedia.org/wiki/Freeze_(software_engineering)) for 1.0, along with a couple new features, and a few bug fixes.

From now on, **Hanami API's are stable and won't be changed until 2.0**.

The stable release (`v1.0.0`) will happen between the end of March and the beginning of April 2017, which coincides with the [Hanami season in Japan](http://www.japan-guide.com/sakura/). 🌸

Between now and then, we'll release other _beta_ and _release candidate_ versions.

## Features

Hanami is now compatible with Ruby 2.3+ (including the latest 2.4) and with Rack 2.0 only.

### Project Logger

We added the project logger, available at `Hanami.logger`.
If you need to log a piece of information, use it like this: `Hanami.logger.debug "hello"`.

Because of this change, the application-specific loggers were removed (eg. `Web.logger`, `Admin.logger`).
Therefore, logger settings for individual application are not supported anymore (e.g. inside `apps/web/application.rb`).
To configure the logger, please edit `config/environment.rb`.

### Automatic Logging

A project that uses Hanami will automatically log each incoming HTTP request, SQL query and migration.

When a project is used in development mode, the logging format is human readable:

```ruby
[bookshelf] [INFO] [2017-02-11 15:42:48 +0100] HTTP/1.1 GET 200 127.0.0.1 /books/1  451 0.018576
[bookshelf] [INFO] [2017-02-11 15:42:48 +0100] (0.000381s) SELECT "id", "title", "created_at", "updated_at" FROM "books" WHERE ("book"."id" = '1') ORDER BY "books"."id"
```

For the production environment, the default format is **JSON** instead.
JSON is parseable and more machine-oriented. It works great with log aggregators or SaaS logging products.

```json
{"app":"bookshelf","severity":"INFO","time":"2017-02-10T22:31:51Z","http":"HTTP/1.1","verb":"GET","status":"200","ip":"127.0.0.1","path":"/books/1","query":"","length":"451","elapsed":0.000391478}
```

Migrations will print on standard output the operations applied to the database schema.

```shell
➜ bundle exec hanami db migrate

[hanami] [INFO] Begin applying migration 20170213123250_create_books.rb, direction: up
[hanami] [INFO] (0.001756s) CREATE TABLE `books` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `name` varchar(255) NOT NULL, `created_at` timestamp NOT NULL, `updated_at` timestamp NOT NULL)
[hanami] [INFO] (0.001738s) INSERT INTO `schema_migrations` (`filename`) VALUES ('20170213123250_create_books.rb')
[hanami] [INFO] Finished applying migration 20170213123250_create_books.rb, direction: up, took 0.004091 seconds
```

### Improved Model Generator

The model generator now creates a migration file for a given entity.

```shell
➜ bundle exec hanami generate model book
      create  lib/bookshelf/entities/book.rb
      create  lib/bookshelf/repositories/book_repository.rb
      create  db/migrations/20170213123250_create_books.rb
      create  spec/bookshelf/entities/book_spec.rb
      create  spec/bookshelf/repositories/book_repository_spec.rb
```

It generates an entity with the corresponding repository, migration, and testing code.

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

### `config/boot.rb`

New projects will be generated with a new file: `config/boot.rb`

```ruby
require_relative './environment'
Hanami.boot
```

This is useful to boot a Hanami project **outside of** the server or the console.
A typical use case is [Sidekiq](http://sidekiq.org).
If you want to run background jobs with this queue, you can start the process with:

```shell
bundle exec sidekiq -r ./config/boot.rb
```

### Minor Changes

For the entire list of changes, please have a look at our [CHANGELOG](https://github.com/hanami/hanami/blob/master/CHANGELOG.md) and [features list](https://github.com/hanami/hanami/blob/master/FEATURES.md).

## Released Gems

  * `hanami-1.0.0.beta1`
  * `hanami-model-1.0.0.beta1`
  * `hamami-controller-1.0.0.beta1`
  * `hanami-assets-1.0.0.beta1`
  * `hanami-mailer-1.0.0.beta1`
  * `hanami-helpers-1.0.0.beta1`
  * `hanami-view-1.0.0.beta1`
  * `hanami-validations-1.0.0.beta1`
  * `hanami-router-1.0.0.beta1`
  * `hanami-utils-1.0.0.beta1`

## Contributors

We're grateful for each person who contributed to this release. These lovely people are:

* [Adrian Madrid](https://github.com/aemadrid)
* [Alfonso Uceda](https://github.com/AlfonsoUceda)
* [Andy Holland](https://github.com/AMHOL)
* [Bhanu Prakash](https://github.com/bhanuone)
* [Gabriel Gizotti](https://github.com/gizotti)
* [Jakub Pavlík](https://github.com/igneus)
* [Kai Kuchenbecker](https://github.com/kaikuchn)
* [Ksenia Zalesnaya](https://github.com/ksenia-zalesnaya)
* [Leonardo Saraiva](https://github.com/vyper)
* [Lucas Hosseini](https://github.com/beauby)
* [Marcello Rocha](https://github.com/mereghost)
* [Marion Duprey](https://github.com/TiteiKo)
* [Marion Schleifer](https://github.com/marionschleifer)
* [Matias H. Leidemer](https://github.com/matiasleidemer)
* [Mikhail Grachev](https://github.com/mgrachev)
* [Nick Rowlands](https://github.com/rowlando)
* [Nikita Shilnikov](https://github.com/flash-gordon)
* [Oana Sipos](https://github.com/oana-sipos)
* [Ozawa Sakuro](https://github.com/sakuro)
* [Pascal Betz](https://github.com/pascalbetz)
* [Philip Arndt](https://github.com/parndt)
* [Piotr Solnica](https://github.com/solnic)
* [Semyon Pupkov](https://github.com/artofhuman)
* [Thorbjørn Hermansen](https://github.com/thhermansen)
* [Tiago Farias](https://github.com/tiagofsilva)
* [Victor Franco](https://github.com/docStonehenge)
* [Vladimir Dralo](https://github.com/vladra)
* [alexd16](https://github.com/alexd16)
* [b264](https://github.com/b264)
* [yjukaku](https://github.com/yjukaku)

## How To Update Your Project

If you're upgrading you project from `v0.9`, please have a look at the related [upgrade guide article](/guides/upgrade-notes/v100beta1).
