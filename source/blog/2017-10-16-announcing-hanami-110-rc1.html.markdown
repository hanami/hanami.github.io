---
title: Announcing Hanami v1.1.0.rc1
date: 2017-10-16 12:30 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Association aliases, entities as types in custom schema, <code>--relation</code> option for model generator, RSpec metadata, bug fixes.
---

Hello wonderful community!

Today we're happy to announce `v1.1.0.rc1` release 🙌 , with the stable release (`v1.1.0`) scheduled **later this month**.

## Features

Here's the **last** minor additions. This version is the **feature freeze** for `v1.1.0`.

### Association aliases

We added support for association aliases via `:as` option.
In this way an association can be referenced by the alias, not the conventional name.

```ruby
class UserRepository < Hanami::Repository
  associations do
    has_many :stories
    has_many :comments
  end
end
```

```ruby
class CommentRepository < Hanami::Repository
  associations do
    belongs_to :story
    belongs_to :user, as: :author
  end
end
```

```ruby
class StoryRepository < Hanami::Repository
  associations do
    belongs_to :user
    has_many :comments
    has_many :users, through: :comments, as: :authors
  end


  def feed
    aggregate(:user, comments: :author).reverse(:created_at).map_to(Story)
  end
end
```

In the example above, `StoryRepository` can reference the author of a comment as `author`, instead of `user`.

### Entities as types in custom schema

Entities by default have a set of attributes (schema) which is the representation of a relation.
For instance `User` will have all the columns of `users` database table.

You can bypass this feature to build customize the attributes via [_custom schema_](http://hanamirb.org/guides/1.0/models/entities/#custom-schema).

Now you can use entities to be an attribute in a _custom schema_ via `Types::Entity()`.

```ruby
class Account < Hanami::Entity
  attributes do
    attribute :id,    Types::Int
    attribute :owner, Types::Entity(User)
  end
end
```

### New option for model generator

We added a new option for the model generator: `--relation`.

```
% bundle exec hanami generate model user --relation=accounts
      create  lib/bookshelf/entities/user.rb
      create  lib/bookshelf/repositories/user_repository.rb
      create  db/migrations/20171016124904_create_accounts.rb
      create  spec/bookshelf/entities/user_spec.rb
      create  spec/bookshelf/repositories/user_repository_spec.rb
```

It will generate a customized version of the database migration, and repository.

```ruby
Hanami::Model.migration do
  change do
    create_table :accounts do
      primary_key :id

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
```

```ruby
class UserRepository < Hanami::Repository
  self.relation = :accounts
end
```

## RSpec metadata

If you're using RSpec, the code generator will create specs with the `:type` metadata:

```ruby
RSpec.describe Web::Controllers::Home::Index, type: :action do
  # ...
end
```

Available types are:

  * `:action`
  * `:view`
  * `:mailer`
  * `:entity`
  * `:repository`


## Released Gems

  * `hanami-1.1.0.rc1`
  * `hanami-model-1.1.0.rc1`
  * `hanami-assets-1.1.0.rc1`
  * `hanami-cli-0.1.0.rc1`
  * `hanami-mailer-1.1.0.rc1`
  * `hanami-helpers-1.1.0.rc1`
  * `hanami-view-1.1.0.rc1`
  * `hamami-controller-1.1.0.rc1`
  * `hanami-router-1.1.0.rc1`
  * `hanami-validations-1.1.0.rc1`
  * `hanami-utils-1.1.0.rc1`

## Contributors

We're grateful for each person who contributed to this release. These lovely people are:

* [Alfonso Uceda](https://github.com/AlfonsoUceda)
* [Anton Davydov](https://github.com/davydovanton)
* [Luca Guidi](https://github.com/jodosha)
* [Marcello Rocha](https://github.com/mereghost)
* [Marion Duprey](https://github.com/TiteiKo)
* [Marion Schleifer](https://github.com/marionschleifer)
* [Oana Sipos](https://github.com/oana-sipos)
* [Sean Collins](https://github.com/cllns)
* [Sergey Fedorov](https://github.com/Strech)
* [Yuji Ueki](https://github.com/unhappychoice)
* [Kirill](https://github.com/likeath)

## How to try it

If you want to try with a new project:

```shell
gem install hanami --pre
hanami new bookshelf
```

If you want to upgrade your existing project, edit the `Gemfile`:

```ruby
# ...
gem "hanami",       "1.1.0.rc1"
gem "hanami-model", "1.1.0.rc1"
```

## What's next?

We'll release the stable release **later this month**, in the meantime, please try this _release candidate_ and report issues.
Happy coding! 🌸
