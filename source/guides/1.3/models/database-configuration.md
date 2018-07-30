---
title: Guides - Database Configuration
version: 1.3
---

# Database Configuration

Before starting your server, you need to configure the database link in <code>.env*</code> files.

Open this file for each environment and update <code>DATABASE_URL</code> for your database.

Setup database variable for the development environment:

```
# .env.development
DATABASE_URL="database_type://username:password@localhost/bookshelf_development"
```

Setup database variable for the test environment:

```
# .env.test
DATABASE_URL="database_type://username:password@localhost/bookshelf_test"
```

For jdbc urls you can't set username and password to the left of @ you have to set them as parameters in the url:

```
DATABASE_URL="jdbc-database_type://localhost/bookshelf_test?user=username&password=password"
```

## Setup your database

After your database variables setup is done you need to create the database and run the migrations before being able to launch a development server.

In your terminal, enter:

```
% bundle exec hanami db prepare
```

To setup your test environment database, enter:

```
% HANAMI_ENV=test bundle exec hanami db prepare
```
