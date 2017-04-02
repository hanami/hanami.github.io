---
title: "Guides - Command Line: Applications"
---

# Command Line

## Applications

We can generate a new project via `hanami new`, followed by the name that we want to use.

```shell
% hanami new bookshelf
```

### Architecture

The default architecture for a newly generated project is _Container_.

We can use the `--architecture` argument (aliased as `--arch`) to specify a different architecture.

It supports:

  * `container` (default)
  * `app`

The following command will generate an `admin` project that uses the _Application_ architecture.

```shell
% hanami new admin --arch=app
```

### Database

The default database engine is SQLite.

We can use the `--database` argument to let Hanami to generate code for a specific database.

It supports:

  * `postgres`
  * `postgresql`
  * `sqlite` (default)
  * `sqlite3`
  * `mysql`
  * `mysql2`

### Testing Framework

The default testing framework is Minitest.

We can use the `--test` argument to specify a different framework, from the list below:

  * `minitest` (default)
  * `rspec`
