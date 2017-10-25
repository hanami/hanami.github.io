---
title: Announcing Hanami v1.1.0
date: 2017-10-25 09:38 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  New associations (<code>belongs_to</code>, <code>has_one</code>, <code>has_many :through</code>), rewritten CLI with registrable commands for third-party gems, new extra behaviors for entity manual schema, selectively boot apps, logger filtering, bug fixes.
---

Hello wonderful community!

This autumn 🍂 has brought to you a new Hanami version🌸 and its cool 😎 new features.

Today we're happy to announce `v1.1.0` release 🙌 .

## Features

So what's new and exiciting in the Hanami world?

## New associations

We added new useful associations. 🎉
Let's quickly see them in action.

### Belongs To

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

[Belongs To guide](/guides/1.1/associations/belongs-to)

### Has One

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

[Has One guide](/guides/1.1/associations/has-one)

### Has Many Through

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

[Has Many Through guide](/guides/1.1/associations/has-many-through)

## Rewritten CLI

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
          desc "Generate Webpack config"

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
  hanami generate webpack                          # Generate Webpack config
```

## Entity Custom Schema modes

Entities by default infer their schema (set of attributes) from the corresponding database table.
For instance, if `people` table has `id`, `name`, `created_at`, and `updated_at` columns, then `Person` will have the same attributes.

It may happen that you're not happy with this inferring, and you want to customize the schema.
We call it this feature ["custom schema"](/guides/1.1/entities/custom-schema).

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

[Entities Custom Schema guide](/guides/1.1/entities/custom-schema)

### Selectively boot apps

With Hanami you can build your project by following the [Monolith-First](/guides/1.1/architecture/overview/#monolith-first) principle.
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

[Logger filtering guide](/guides/1.1/projects/logging#filter-sensitive-informations)

### Minor Changes

For the entire list of changes, please have a look at our [CHANGELOG](https://github.com/hanami/hanami/blob/master/CHANGELOG.md) and [features list](https://github.com/hanami/hanami/blob/master/FEATURES.md).

## Released Gems

  * `hanami-1.1.0` - [[CHANGELOG](https://github.com/hanami/hanami/blob/master/CHANGELOG.md)]
  * `hanami-model-1.1.0` - [[CHANGELOG](https://github.com/hanami/model/blob/master/CHANGELOG.md)]
  * `hanami-assets-1.1.0` - [[CHANGELOG](https://github.com/hanami/assets/blob/master/CHANGELOG.md)]
  * `hanami-cli-0.1.0` - [[CHANGELOG](https://github.com/hanami/cli/blob/master/CHANGELOG.md)]
  * `hanami-mailer-1.1.0` - [[CHANGELOG](https://github.com/hanami/mailer/blob/master/CHANGELOG.md)]
  * `hanami-helpers-1.1.0` - [[CHANGELOG](https://github.com/hanami/helpers/blob/master/CHANGELOG.md)]
  * `hanami-view-1.1.0` - [[CHANGELOG](https://github.com/hanami/view/blob/master/CHANGELOG.md)]
  * `hamami-controller-1.1.0` - [[CHANGELOG](https://github.com/hanami/controller/blob/master/CHANGELOG.md)]
  * `hanami-router-1.1.0` - [[CHANGELOG](https://github.com/hanami/router/blob/master/CHANGELOG.md)]
  * `hanami-validations-1.1.0` - [[CHANGELOG](https://github.com/hanami/validations/blob/master/CHANGELOG.md)]
  * `hanami-utils-1.1.0` - [[CHANGELOG](https://github.com/hanami/utils/blob/master/CHANGELOG.md)]

## Contributors

We're grateful for each person who contributed to this release. These lovely people are:

* [Alfonso Uceda](https://github.com/AlfonsoUceda)
* [Anton Davydov](https://github.com/davydovanton)
* [Bartosz Bonisławski](https://github.com/bbonislawski)
* [Ben Johnson](https://github.com/binarylogic)
* [Brooke Kuhlmann](https://github.com/bkuhlmann)
* [Cecile Veneziani](https://github.com/cveneziani)
* [Daniel Amireh](https://github.com/damireh)
* [David Dymko](https://github.com/ddymko)
* [Dmitriy Ivliev](https://github.com/moofkit)
* [Dmitriy Strukov](https://github.com/dmitriy-strukov)
* [Ferdinand Niedermann](https://github.com/nerdinand)
* [Gabriel Gizotti](https://github.com/gizotti)
* [Gernot Poetsch](https://github.com/gernot)
* [Hélio Costa e Silva](https://github.com/hlegius)
* [Ilya Ponomarev](https://github.com/ilyario)
* [Janko Marohnić](https://github.com/janko-m)
* [Jaymie Jones](https://github.com/jaymiejones86)
* [John Hager](https://github.com/jphager2)
* [Kai Kuchenbecker](https://github.com/kaikuchn)
* [Karolis Mažukna](https://github.com/Nikamura)
* [Kate Donaldson](https://github.com/katelovescode)
* [Kirill](https://github.com/likeath)
* [Koichi ITO](https://github.com/koic)
* [Luca Guidi](https://github.com/jodosha)
* [Lucas Hosseini](https://github.com/beauby)
* [Marcello Rocha](https://github.com/mereghost)
* [Marion Duprey](https://github.com/TiteiKo)
* [Marion Schleifer](https://github.com/marionschleifer)
* [Masato Oba](https://github.com/masatooba)
* [Maurizio De Magnis](https://github.com/olistik)
* [Miguel Angel Arenas Correa](https://github.com/maac4422)
* [Nick Pridorozhko](https://github.com/nplusp)
* [Nicolas Filzi](https://github.com/nfilzi)
* [Nikita Shilnikov](https://github.com/flash-gordon)
* [Oana Sipos](https://github.com/oana-sipos)
* [Paul Smith](https://github.com/paulcsmith)
* [Paweł Świątkowski](https://github.com/katafrakt)
* [Phil Nash](https://github.com/philnash)
* [Piotr Solnica](https://github.com/solnic)
* [Radan Skorić](https://github.com/radanskoric)
* [Rogério Zambon](https://github.com/rogeriozambon)
* [Ruslan Gafurov](https://github.com/Shkrt)
* [Sean Collins](https://github.com/cllns)
* [Semyon Pupkov](https://github.com/artofhuman)
* [Sergey Fedorov](https://github.com/Strech)
* [Sergey Sein](https://github.com/linchus)
* [Thiago Kenji Okada](https://github.com/m45t3r)
* [Tim Riley](https://github.com/timriley)
* [Tudor Pavel](https://github.com/tudorpavel)
* [Vladislav Yashin](https://github.com/funk-yourself)
* [Xavier Barbosa](https://github.com/johnnoone)
* [Yousuf J](https://github.com/yjukaku)
* [Yuji Ueki](https://github.com/unhappychoice)
* [Yuji Yaginuma](https://github.com/y-yagi)
* [akhramov](https://github.com/akhramov)
* [autopp](https://github.com/autopp)
* [chenge](https://github.com/chenge)
* [derekpovah](https://github.com/derekpovah)
* [graywolf](https://github.com/graywolf)
* [jarosluv](https://github.com/jarosluv)
* [malin-as](https://github.com/malin-as)
* [mbajur](https://github.com/mbajur)
* [milovidov](https://github.com/milovidov)
* [morrme](https://github.com/morrme)
* [ryu39](https://github.com/ryu39)
* [sovetnik](https://github.com/sovetnik)
* [yjukaku](https://github.com/yjukaku)

## How to install

If you're new to Hanami, you can install via:

```shell
gem install hanami
hanami new bookshelf
```

You may want to follow our great [_getting started guide_](/guides/1.1/getting-started).

## How to upgrade

Update `hanami` and `hanami-model` in your `Gemfile`:

```ruby
gem "hanami",       "~> 1.1"
gem "hanami-model", "~> 1.1"
```

Then run `bundle update hanami hanami-model`.

For a detailed explanation, check the [upgrade guide](/guides/1.1/upgrade-notes/v110).

## What's next?

We'll start tomorrow the next release cycle for **Hanami 1.2**, the **first beta** will be released on **February 2018**.

Happy coding! 🌸
