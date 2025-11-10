---
title: "Hanami 2.3: Racked and Ready"
date: 2025-11-12 09:30:00 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  TODO WOO
---

## Built for Rack 3

With this release, we introduce Rack 3 support to Hanami!

We now support both versions 2 and 3, so you can use whichever version of Rack suits your situation. We encourage you to upgrade Rack when you can, and we’re happy that Hanami is no longer a blocker on this path.

When you decide to upgrade to Rack 3, check out the [Rack 3 upgrade guide](https://github.com/rack/rack/blob/main/UPGRADE-GUIDE.md). The essential changes are handled for you by Hanami, but you may need to update some of your app code if you’re working with Rack request/response details.

## Streamlined from route to response

write words here

plus more routing and request handling improvements:

- router: scopes with `as:` for name prefix
- router: route names specifying own prefix
- The router sees a big runtime performance boost for large numbers of routes, addressing a performance regression that was introduced as part of some fixes in Hanami 2.2.
- parsing of multipart and JSON request bodies by default
- Improved action formats config
- Access subdomains using `Request#subdomains`, and configure your default TLD length with `config.actions.default_tld_length`.
- When you specify `'nonce'` in your content security policy, a nonce is automatically added to `javascript_tag` and `stylesheet_tag`.
- controller: load CSRF tokens from X-CSRF-Token header

## DX in the details

- Running `hanami new` will now initialize a Git repository in your new app.
- --gem-source option for hanami new
- new options: --skip-view
- bin/setup script, improved README
- bin/hanami binstub (and rake)
- Run `hanami db rollback` to easily rollback a database migration.
- Add your own methods to `hanami console` via own modules. Add `config.console.include MyModule, AnotherModule` to your app class.
- Prefer Pry to IRB? Make it the default with `config.console.engine = :pry`.
- print one-time warning when accessing keys in console (plus console --boot flag)
- The default `Rakefile` will automatically load custom tasks from the conventional `lib/tasks/` location.
- generate view context class
- generate improvements
  - Run any `hanami generate` command inside a slice directory and the slice will automatically be used as the target for the new files.
  - `hanami generate action` now accepts a `--skip-tests` flag.
  - `hanami generate action` will add routes to slice-specific `config/routes.rb` files, if present.
  - `hanami generate` commands now graceully handle names given with mixed cases.

plus many other small improvements and fixes. check out the CHANGELOGS (todo: link to CHANGELOGs)

We’re just getting started. We’d love to see you help improve our DX.

## Try it yourself

if you have an existing app, check out the upgrade notes.

we've updated our getting started guide to be more concise; tests at the end. give it a look!

```shell
$ gem install hanami
$ hanami new my_app
$ cd my_app
$ bundle exec hanami dev
$ open http://localhost:2300
```

## How 'bout our team yo

Our biggest contributing group yet!

- [Aaron Allen](https://github.com/aaronmallen)
- [Adam Lassek](https://github.com/alassek)
- [Alexander Gräfe](https://github.com/rickenharp)
- [Alexander Zagaynov](https://github.com/AlexanderZagaynov)
- [Andrea Fomera](https://github.com/afomera)
- [Brandon Weaver](https://github.com/baweaver)
- [David Celis](https://github.com/davidcelis)
- [Hana Rimawi](https://github.com/hanarimawi)
- [inouire](https://github.com/inouire)
- [Jared White](https://github.com/jaredcwhite)
- [Krzysztof Piotrowski](https://github.com/krzykamil)
- [Kyle Plump](https://github.com/kyleplump)
- [Mathew Button](https://github.com/mathewdbutton)
- [Max Mitchell](https://github.com/maxemitchell)
- [Mina Slater](https://github.com/minaslater)
- [Paweł Świątkowski](https://github.com/katafrakt)
- [Petrik de Heus](https://github.com/p8)
- [Rob Yurkowski](https://github.com/robyurkowski)
- [Sean Collins](https://github.com/cllns)
- [Simon Thiboutôt](https://github.com/masterT)
- [stephannv](https://github.com/stephannv)
- [Sven Schwyn](https://github.com/svoop)
- [Tim Morgan](https://github.com/seven1m)
- [Tim Riley](https://github.com/timriley)
- [William Tio](https://github.com/WToa)
- [Wout](https://github.com/wout)
- [wuarmin](https://github.com/wuarmin)
- [y-yagi](https://github.com/y-yagi)
