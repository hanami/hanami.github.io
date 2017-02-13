---
title: Announcing Hanami v1.0.0.beta1
date: 2017-02-13 14:54 UTC
tags: announcements
author: Oana Sipos
image: true
excerpt: >
  Major release which improves the project logger, the automatic logging of HTTP requests, migrations, and SQL queries and other small fixes.
---

This is a major release:

  * Official support for Ruby: MRI 2.4
  * CLI: hanami generate model now also generates a migration
  * Generate `config/boot.rb` for new Hanami projects.
  * Introduced Hanami.logger as project logger
  * Automatic logging of HTTP requests, migrations, and SQL queries
  * Introduced environment for env specific settings in config/environment.rb
  * Don't include bundler as a dependency Gemfile for new Hanami projects
  * Make compatible with Rack 2.0 only
  * Removed logger (and its settings) for Hanami applications
  * Changed mailer syntax in `config/enviroment.rb`
  * Serve only existing assets with Hanami::Static
  * Ensure inline ENV vars to not be overwritten by `.env.*` files
  * Ensure new Hanami projects have the correct jdbc prefix for JRuby
  * Fixed code reloading for objects under `lib/`
  * Ensure generated mailer to respect the project name under `lib/`
  * Fixed generation of mailer settings for new projects
  * Fixed CLI subcommands help output

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
* [Tiago Farias](https://github.com/tiagofsilva)
* [Thorbjørn Hermansen](https://github.com/thhermansen)
* [Vladimir Dralo](https://github.com/vladra)
* [alexd16](https://github.com/alexd16)
* [b264](https://github.com/b264)
* [yjukaku](https://github.com/yjukaku)

## How To Update Your Project

From the root of your Hanami project: `bundle update hanami`.
