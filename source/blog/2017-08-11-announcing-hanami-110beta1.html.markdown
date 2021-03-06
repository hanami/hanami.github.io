---
title: Announcing Hanami v1.1.0.beta1
date: 2017-08-11 19:41 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  New associations (<code>belongs_to</code>, <code>has_one</code>, <code>has_many :through</code>), rewritten CLI with registrable commands for third-party gems, new extra behaviors for entity manual schema, selectively boot apps, logger filtering, bug fixes.
---

Hello wonderful community!

This hot summer ☀ has some fresh news brought to you by Hanami 🌸 and its cool 😎 new features. 🍉

Today we're happy to announce `v1.1.0.beta1` release 🙌 , with the stable release (`v1.1.0`) scheduled for **October 2017**.

Between now and then, we'll release other _beta_ and _release candidate_ versions.

## Features

So what's new and exiciting in the Hanami world?

### New repository associations

We added new useful associations. 🎉
Let's quickly see them in action.

#### Many-to-One (`belongs_to`)

```ruby
class BookRepository < Hanami::Repository
  associations do
    belongs_to :author
  end

  def find_with_author(id)
    aggregate(:author).where(id: id).map_to(Book).one
  end
end
```

#### One-to-one (`has_one`)

```ruby
class UserRepository < Hanami::Repository
  associations do
    has_one :avatar
  end

  def find_with_avatar(id)
    aggregate(:avatar).where(id: id).map_to(User).one
  end

  def create_with_avatar(data)
    assoc(:avatar).create(data)
  end

  def remove_avatar(user)
    assoc(:avatar, user).delete
  end

  def add_avatar(user, data)
    assoc(:avatar, user).add(data)
  end

  def update_avatar(user, data)
    assoc(:avatar, user).update(data)
  end

  def replace_avatar(user, data)
    assoc(:avatar, user).replace(data)
  end
end
```

#### Many-to-many (`has_many :through`)

```ruby
class AuthorRepository < Hanami::Repository
  associations do
    has_many :books
    has_many :reviews, through: :books
  end

  def find_with_reviews(id)
    aggregate(:reviews).where(authors__id: id).map_to(Author).one
  end

  def top_reviews_for(author)
    assoc(:reviews, author).where("usefulness_count > 10").to_a
  end
end
```

### Rewritten CLI

We have rewritten from scratch our CLI, by replacing `thor` with a new gem `hanami-cli`.

Despite the name, [`hanami-cli`](https://github.com/hanami/cli) is **not** about Hanami commands (eg. `hanami server`), but instead it's a **general purpose Command Line Interface (CLI) framework for Ruby**.
We worked with [dry-rb](http://dry-rb.org) team to ship this new gem, which is be used by Hanami, and it will be used soon by dry-rb, [ROM](http://rom-rb.org/) and [Trailblazer](http://trailblazer.to/) to build their CLI too.

Thanks to `hanami-cli` we built a new CLI architecture that allows third-party developers to integrate with Hanami CLI.
Let's say we want to build a fictional gem `hanami-webpack`.

```ruby
require "hanami/cli/commands"

module Hanami
  module Webpack
    module CLI
      module Commands
        class Configuration < Hanami::CLI::Commands::Command
          desc "Generate Webpack configuration"

          def call(*)
            # generate configuration
          end
        end
      end
    end
  end
end

Hanami::CLI.register "generate webpack", Hanami::Webpack::CLI::Commands::Configuration
```

When a developer adds `hanami-webpack` to their `Gemfile`, then the command is available.

```shell
$ bundle exec hanami generate
Commands:
  hanami generate action APP ACTION                # Generate an action for app
  hanami generate app APP                          # Generate an app
  hanami generate mailer MAILER                    # Generate a mailer
  hanami generate migration MIGRATION              # Generate a migration
  hanami generate model MODEL                      # Generate a model
  hanami generate secret [APP]                     # Generate session secret
  hanami generate webpack                          # Generate Webpack configuration
```

### Extra behaviors for entity manual schema

Entities by default infer their schema (set of attributes) from the corresponding database table.
For instance, if `people` table has `id`, `name`, `created_at`, and `updated_at` columns, then `Person` will have the same attributes.

It may happen that you're not happy with this inferring, and you want to customize the schema.
We call it this feature ["manual schema"](/guides/1.0/models/entities/#manual-schema).

It was introduced with Hanami 1.0 and this is how it works:

```ruby
class Person < Hanami::Entity
  attributes do
    attribute :id,   Types::Int
    attribute :name, Types::String
  end
end

Person.new
=> #<Person:0x007ff859e34118 @attributes={}>

Person.new(id: 1)
# => #<Person:0x007ff85acbcfc8 @attributes={:id=>1}>

Person.new(id: "1")
# => #<Person:0x007ff85a04d558 @attributes={:id=>"1"}>

Person.new(id: 1, name: "Luca")
# => #<Person:0x007ff85ab20200 @attributes={:id=>1, :name=>"Luca"}>

Person.new(id: 1, name: "Luca", foo: "bar")
# => #<Person:0x007ff859e44ea0 @attributes={:id=>1, :name=>"Luca"}>

Person.new(foo: "bar")
# => #<Person:0x007ff859e4d1e0 @attributes={}>
```

With Hanami 1.1, you can expand the behavior of your _manual schema_.
Do you want a stricter policy for entity initialization? You got it!

```ruby
class Person < Hanami::Entity
  attributes :strict do
    attribute :id,   Types::Strict::Int
    attribute :name, Types::Strict::String
  end
end

Person.new
# => ArgumentError: :id is missing in Hash input

Person.new(id: 1)
# => ArgumentError: :name is missing in Hash input

Person.new(id: 1, name: "Luca")
# => #<Person:0x007f8476816c88 @attributes={:id=>1, :name=>"Luca"}>

Person.new(id: 1, name: "Luca", foo: "bar")
# => ArgumentError: unexpected keys [:foo] in Hash input

Person.new(foo: "bar")
# => ArgumentError: unexpected keys [:foo] in Hash input

Person.new(id: "1", name: "Luca")
# => TypeError: "1" (String) has invalid type for :id violates constraints (type?(Integer, "1") failed)
```

### Selectively boot apps

With Hanami you can build your project by following the [Monolith-First](/guides/1.0/architecture/overview/#monolith-first) principle.
You add more and more code to the project, but growing it organically, by using several Hanami apps.

There are cases of real world products using a **dozen of Hanami apps in the same project** (eg `web` for the frontend, `admin` for the administration, etc..)
They deploy the project on several servers, by booting only a subset of these apps.
So the servers A, B, and C are for customers (`web` application), D is for administration (`admin` application), while E, and F are for API (`api` application)

To serve this purpose we introduced _selective booting_ feature.


```ruby
# config/environment.rb
# ...
Hanami.configure do
  if Hanami.app?(:api)
    require_relative '../apps/api/application'
    mount Api::Application, at: '/api'
  end

  if Hanami.app?(:admin)
    require_relative '../apps/admin/application'
    mount Api::Application, at: '/admin'
  end

  if Hanami.app?(:web)
    require_relative '../apps/web/application'
    mount Api::Application, at: '/'
  end
end
```

Then from the CLI, you use the `HANAMI_APPS` env var.

```shell
$ HANAMI_APPS=web,api bundle exec hanami server
```

With the command above we start only `web` and `api` applications.

### Logger filtering

With this release, we automatically log the payload from non-GET HTTP requests.
When a user submits a form, all the fields and their values will appear in the log:

```shell
[bookshelf] [INFO] [2017-08-11 18:17:54 +0200] HTTP/1.1 POST 302 ::1 /signup 5 {"signup"=>{"username"=>"jodosha", "password"=>"secret", "password_confirmation"=>"secret", "bio"=>"lorem"}} 0.00593
```

To avoid sensitive informations to be logged, you can filter them:

```ruby
# config/environment.rb
# ...

Hanami.configure do
  # ...
  environment :development do
    logger level: :debug, filter: %w[password password_confirmation]
  end
end
```

Now the output will be:

```shell
[bookshelf] [INFO] [2017-08-11 18:17:54 +0200] HTTP/1.1 POST 302 ::1 /signup 5 {"signup"=>{"username"=>"jodosha", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]", "bio"=>"lorem"}} 0.00593
```

It also supports fine grained patterns to disambiguate params with the same name.
For instance, we have a billing form with street number and credit card number, and we want only to filter the credit card:

```ruby
# config/environment.rb
# ...

Hanami.configure do
  # ...
  environment :development do
    logger level: :debug, filter: %w[credit_card.number]
  end
end
```

```shell
[bookshelf] [INFO] [2017-08-11 18:43:04 +0200] HTTP/1.1 PATCH 200 ::1 /billing 2 {"billing"=>{"name"=>"Luca", "address"=>{"street"=>"Centocelle", "number"=>"23", "city"=>"Rome"}, "credit_card"=>{"number"=>"[FILTERED]"}}} 0.009782
```

Note that `billing => address => number` wasn't filtered while `billing => credit_card => number` was filtered instead.

### Minor Changes

For the entire list of changes, please have a look at our [CHANGELOG](https://github.com/hanami/hanami/blob/master/CHANGELOG.md) and [features list](https://github.com/hanami/hanami/blob/master/FEATURES.md).

## Released Gems

  * `hanami-1.1.0.beta1`
  * `hanami-model-1.1.0.beta1`
  * `hanami-assets-1.1.0.beta1`
  * `hanami-cli-0.1.0.beta1`
  * `hanami-mailer-1.1.0.beta1`
  * `hanami-helpers-1.1.0.beta1`
  * `hanami-view-1.1.0.beta1`
  * `hamami-controller-1.1.0.beta1`
  * `hanami-router-1.1.0.beta1`
  * `hanami-validations-1.1.0.beta1`
  * `hanami-utils-1.1.0.beta1`

## Contributors

We're grateful for each person who contributed to this release. These lovely people are:

* [Alfonso Uceda](https://github.com/AlfonsoUceda)
* [Anton Davydov](https://github.com/davydovanton)
* [Bartosz Bonisławski](https://github.com/bbonislawski)
* [Ben Johnson](https://github.com/binarylogic)
* [Cecile Veneziani](https://github.com/cveneziani)
* [Daniel Amireh](https://github.com/damireh)
* [David Dymko](https://github.com/ddymko)
* [Dmitriy Ivliev](https://github.com/moofkit)
* [Ferdinand Niedermann](https://github.com/nerdinand)
* [Gabriel Gizotti](https://github.com/gizotti)
* [Gernot Poetsch](https://github.com/gernot)
* [Hélio Costa e Silva](https://github.com/hlegius)
* [Jaymie Jones](https://github.com/jaymiejones86)
* [John Hager](https://github.com/jphager2)
* [Kai Kuchenbecker](https://github.com/kaikuchn)
* [Karolis Mažukna](https://github.com/Nikamura)
* [Koichi ITO](https://github.com/koic)
* [Luca Guidi](https://github.com/jodosha)
* [Lucas Hosseini](https://github.com/beauby)
* [Marcello Rocha](https://github.com/mereghost)
* [Marion Duprey](https://github.com/TiteiKo)
* [Marion Schleifer](https://github.com/marionschleifer)
* [Maurizio De Magnis](https://github.com/olistik)
* [Nick Pridorozhko](https://github.com/nplusp)
* [Nikita Shilnikov](https://github.com/flash-gordon)
* [Oana Sipos](https://github.com/oana-sipos)
* [Paweł Świątkowski](https://github.com/katafrakt)
* [Radan Skorić](https://github.com/radanskoric)
* [Rogério Zambon](https://github.com/rogeriozambon)
* [Sean Collins](https://github.com/cllns)
* [Semyon Pupkov](https://github.com/artofhuman)
* [Sergey Sein](https://github.com/linchus)
* [Tim Riley](https://github.com/timriley)
* [Tudor Pavel](https://github.com/tudorpavel)
* [akhramov](https://github.com/akhramov)
* [autopp](https://github.com/autopp)
* [chenge](https://github.com/chenge)
* [derekpovah](https://github.com/derekpovah)
* [jarosluv](https://github.com/jarosluv)
* [mbajur](https://github.com/mbajur)
* [milovidov](https://github.com/milovidov)
* [morrme](https://github.com/morrme)
* [ryu39](https://github.com/ryu39)
* [sovetnik](https://github.com/sovetnik)
* [yjukaku](https://github.com/yjukaku)

## How to try it

```shell
gem install hanami --pre
hanami new bookshelf
```

## What's next?

We'll release the stable release on **October 2017**, in the meantime, please try this beta and report issues.
Happy coding! 🌸
