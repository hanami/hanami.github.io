---
title: Announcing Hanami 2.3 beta1
date: 2025-10-03 08:20:00 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  Rack 3 support and so much more. Help us with your testing!
---

After getting set up for [sponsorship](https://sponsor.hanamirb.org) (we still want to hear from you!), we’re back with a new Hanami release. Today we’re pleased to announce the first beta of Hanami 2.3.

## Rack 3 support

> This one goes up to <s>eleven</s> three.

With this release, we introduce Rack 3 support to Hanami!

We now support Rack versions 2 and 3, so you can use whichever version suits your situation. We still encourage you to upgrade Rack when you can, and we’re happy that Hanami is no longer a blocker on this path.

To upgrade your app to Rack 3, update your Hanami gems to this beta release, then `bundle update rack`. You should also check out the [Rack 3 upgrade guide](https://github.com/rack/rack/blob/main/UPGRADE-GUIDE.md). Most changes will be handled for you by the Hanami gems, but you may need to update some of your app code if you're dealing with lower-level request/response details.

## Improvements

This beta also brings a range of nice improvements to your Hanami experience:

- Add your own methods to `hanami console` via own modules. Add `config.console.include MyModule, AnotherModule` to your app class.
- Prefer Pry to IRB? Make it the default with `config.console.engine = :pry`.
- When you specify `'nonce'` in your content security policy, a nonce is automatically added to `javascript_tag` and `stylesheet_tag`.
- Access subdomains using `Request#subdomains`, and configure your default TLD length with `config.actions.default_tld_length`.
- Redirect to absolute URLs in route definitions: `redirect '/example', to: https://example.com, code: 302`
- You can now use single-character slice names.
- Run any `hanami generate` command inside a slice directory and the slice will automatically be used as the target for the new files.
- Run `hanami db rollback` to easily rollback a database migration.
- Running `hanami new` will now initialize a Git repository in your new app.
- Run `hanami new` with `--skip-view` to skip generating the view layer.
- The default `Rakefile` will automatically load custom tasks from the conventional `lib/tasks/` location.
- The `README.md` in newly generated apps now includes some helpful instructions for next steps.

## Fixes

We’ve also fixed a bunch of bugs:

- Allow access to autoloaded constants in `config/routes.rb`.
- Support `include Deps` in repo classes.
- Avoid false negatives for content type matches in actions.
- Properly show database errors arising from `hanami db` commands.
- Skip ENV var processing by Foreman (run via `hanami dev` by default) to ensure consistent ENV loading across environemnts.
- Respect app inflections when running `hanami generate` commands.
- Prevent `generate` commands from overwriting files.
- Convert special characters to underscores in route helper names.
- Include all necessary gems when running `hanami new` with the `--head` option.

## We need your help!

Our Rack 3 upgrade is one of the more intricate changes we’ve made, especially considering the broad ecosystem that depends on Rack. We need your help to make sure this goes smoothly!

If you have a Hanami app, please try upgrading to 2.3.0.beta1 and Rack 3, and let us know how you go!

## How can I try it?

```
> gem install hanami --pre
> hanami new my_app
> cd my_app
> bundle exec hanami dev
```

## What’s included?

Today we’re releasing the following:

- hanami v2.3.0.beta1
- hanami-assets v2.3.0-beta.1 (npm package)
- hanami-assets v2.3.0.beta1
- hanami-cli v2.3.0.beta1
- hanami-controller v2.3.0.beta1
- hanami-db v2.3.0.beta1
- hanami-reloader v2.3.0.beta1
- hanami-router v2.3.0.beta1
- hanami-rspec v2.3.0.beta1
- hanami-utils v2.3.0.beta1
- hanami-validations v2.3.0.beta1
- hanami-view v2.3.0.beta1
- hanami-webconsole v2.3.0.beta1

For the full list of changes, please see each package’s own CHANGELOG.

## What’s next?

We have a short list of remaining fixes and improvements to make before a proper 2.3 release. See [this GitHub project](https://github.com/orgs/hanami/projects/12/views/1) for details.

I anticipate we’ll do one more beta release, followed by the final 2.3 release.

## Thank you to our contributors!

Thank you to all these amazing people who contributed to this release!

- [Aaron Allen](https://github.com/aaronmallen)
- [Adam Lassek](https://github.com/alassek)
- [Alexander Zagaynov](https://github.com/AlexanderZagaynov)
- [Andrea Fomera](https://github.com/afomera)
- [Hana Rimawi](https://github.com/hanarimawi)
- [inouire](https://github.com/inouire)
- [Krzysztof Piotrowski](https://github.com/krzykamil)
- [Kyle Plump](https://github.com/kyleplump)
- [Max Mitchell](https://github.com/maxemitchell)
- [Paweł Świątkowski](https://github.com/katafrakt)
- [Sean Collins](https://github.com/cllns)
- [stephannv](https://github.com/stephannv)
- [Sven Schwyn](https://github.com/svoop)
- [Tim Morgan](https://github.com/seven1m)
- [Tim Riley](https://github.com/timriley)
- [William Tio](https://github.com/WToa)
- [Wout](https://github.com/wout)
- [wuarmin](https://github.com/wuarmin)
- [y-yagi](https://github.com/y-yagi)

And thank you again for giving this beta a try! We’re looking forward to hearing your feedback. 🌸
