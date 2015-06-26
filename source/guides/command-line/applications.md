---
title: "Lotus - Guides - Command Line: Applications"
---

# Command Line

## Applications

We can generate a new project via `lotus new`, followed by the name that we want to use.

```shell
% lotus new bookshelf
```

### Architecture

The default architecture for a newly generated project is _Container_.

We can use `--architecture` (aliased as `--arch`) to specify another value.


```shell
% lotus new admin --arch=app
```

This will generate an `admin` project that uses the _Application_ architecture.

### Database

The default storage used is a toy file system database.
This is because we want to provide a quick prototyping tool.

We can use `--database` argument to let Lotus to generate code for a specific data store.

It supports:

  * `filesystem` (default)
  * `memory`
  * `postgres`
  * `postgresql`
  * `sqlite`
  * `sqlite3`
  * `mysql`

### Testing Framework

The default testing framework is Minitest.

We can use `--test` argument to specify a different framework, from the list below:

  * `minitest` (default)
  * `rspec`
