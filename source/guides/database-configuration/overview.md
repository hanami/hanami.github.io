---
title: Guides - Database Configuration Overview
---

# Overview

Before starting your server, you need to configure database link in <code>.env*</code> files.

Open this file for each environment and update <code>DATABASE_URL</code> for your database.

## <a href="http://www.postgresql.org/" target="_blank">PostgreSQL</a>

Setup database variable for the development environment:

```
# .env.development
DATABASE_URL="postgres://username:password@localhost/bookshelf_development"
```

Setup database variable for the test environment:

```
# .env.test
DATABASE_URL="postgres://username:password@localhost/bookshelf_test"
```

## Prepare tables in database

After your database variables setup is done you need to create a table in your database before you're be able to launch a development server.
In your terminal, enter:

```
% bundle exec hanami db prepare
```

To create a table in database for the test environment, enter:

```
% HANAMI_ENV=test bundle exec hanami db prepare
```
