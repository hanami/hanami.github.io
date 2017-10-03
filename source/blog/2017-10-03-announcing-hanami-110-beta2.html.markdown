---
title: Announcing Hanami v1.1.0.beta2
date: 2017-10-03 17:53 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Initial support for Hanami plugins, new database CLI command <code>hanami db rollback</code>, add error messages to params, bug fixes.
---

Hello wonderful community!

Today we're happy to announce `v1.1.0.beta2` release 🙌 , with the stable release (`v1.1.0`) scheduled **later this month**.

## Features

So what's new and exiciting in the Hanami world?

### Hanami plugins

We're starting to support Hanami plugins.
Hanami plugins are gems that can integrate with Hanami projects.

The first thing plugins are be able to do is to provide custom CLI commands.
A developer that needs to use a plugin, can add it to the `:plugins` group to the `Gemfile`.

```ruby
# Gemfile
# ...

group :plugins do
  gem "hanami-reloader"
end
```

Here's a first working example of how to implement it: [`hanami-reloader`](https://github.com/jodosha/hanami-reloader).
It's an experimental reloader gem for Hanami, based on [`guard`](http://guardgem.org/).

### Database CLI

We added `hanami db rollback` to rollback database migrations.

By default it rolls back the latest migration, but you can specify a number of _steps_ to rollback:

```shell
bundle exec hanami db rollback   # rolls back the last migration
bundle exec hanami db rollback 5 # rolls back the last five migrations
```

### Params extra error messages

It's now possible to add error messages to Action's params via `params.errors.add`:

```ruby
module Web::Controllers::User
  class Create
    include Web::Action

    params do
      required(:user).schema do
        required(:name).filled(:str?)
        required(:email).filled(:str?)
      end
    end

    def call(params)
      return unless params.valid?
      UserRepository.new.create(params[:user])
    rescue Hanami::Model::UniqueConstraintViolationError
      params.errors.add(:email, "is not unique")
    end
  end
end
```

## Released Gems

  * `hanami-1.1.0.beta2`
  * `hanami-model-1.1.0.beta2`
  * `hanami-assets-1.1.0.beta2`
  * `hanami-cli-0.1.0.beta2`
  * `hanami-mailer-1.1.0.beta2`
  * `hanami-helpers-1.1.0.beta2`
  * `hanami-view-1.1.0.beta2`
  * `hamami-controller-1.1.0.beta2`
  * `hanami-router-1.1.0.beta2`
  * `hanami-validations-1.1.0.beta2`
  * `hanami-utils-1.1.0.beta2`

## Contributors

We're grateful for each person who contributed to this release. These lovely people are:

* [Alfonso Uceda](https://github.com/AlfonsoUceda)
* [Anton Davydov](https://github.com/davydovanton)
* [Gabriel Gizotti](https://github.com/gizotti)
* [Luca Guidi](https://github.com/jodosha)
* [Marcello Rocha](https://github.com/mereghost)
* [Marion Duprey](https://github.com/TiteiKo)
* [Marion Schleifer](https://github.com/marionschleifer)
* [Oana Sipos](https://github.com/oana-sipos)
* [Sean Collins](https://github.com/cllns)

## How to try it

If you want to try with a new project:

```shell
gem install hanami --pre
hanami new bookshelf
```

If you want to upgrade your existing project, edit the `Gemfile`:

```ruby
# ...
gem "hanami",       "1.1.0.beta2"
gem "hanami-model", "1.1.0.beta2"
```

## What's next?

We'll release the stable release **later this month**, in the meantime, please try this beta and report issues.
Happy coding! 🌸
