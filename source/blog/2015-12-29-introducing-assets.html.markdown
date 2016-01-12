---
title: Introducing Assets
date: 2015-12-29 16:12 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Introducing assets features: helpers, preprocessors, EcmaScript 6, deployment, checksums, CDN, and third party gems!
---

We're proud to announce that the upcoming release of Lotus (`v0.6.0`) will ship with a new set of facilities for assets management.

## Helpers

A bunch of **new helpers** is available for your views and templates, with the purpose of building rich web pages:

  * `javascript`
  * `stylesheet`
  * `favicon`
  * `image`
  * `video`
  * `audio`
  * `asset_path`
  * `asset_url`

They have the role of assist you in the process of keeping your templates tidy.
At the same time, they are able to output structured HTML and manage complex URL logic.

Here's a basic example:

```erb
<!doctype HTML>
<html>
  <head>
    <title>Assets example</title>
    <%= stylesheet 'reset', 'grid', 'main' %>
  </head>

  <body>
    <%= yield %>
    <%= javascript 'https://code.jquery.com/jquery-2.1.4.min.js', 'application' %>
    <%= javascript 'modals' %>
  </body>
</html>
```

And the result.

```html
<!doctype HTML>
<html>
  <head>
    <title>Assets example</title>
    <link href="/assets/reset.css" type="text/css" rel="stylesheet">
    <link href="/assets/grid.css" type="text/css" rel="stylesheet">
    <link href="/assets/main.css" type="text/css" rel="stylesheet">
  </head>

  <body>
  <!-- ... -->
  <script src="https://code.jquery.com/jquery-2.1.4.min.js" type="text/javascript"></script>
  <script src="/assets/application.js" type="text/javascript"></script>
  <script src="/assets/modals.js" type="text/javascript"></script>
  </body>
</html>
```

## Preprocessors

Lotus now supports assets preprocessors.
You can write stylesheets with [Sass](http://sass-lang.com) or javascripts with [ES6](http://es6-features.org) syntax and let the framework to lazy compile them during development of precompile all of them at the deploy time.

We use [Tilt](https://github.com/rtomayko/tilt) to provide support for the most common libraries, such as [Less](http://lesscss.org), [JSX](https://jsx.github.io), [CoffeScript](http://coffeescript.org), [Opal](http://opalrb.org), [Handlebars](http://handlebarsjs.com), [JBuilder](https://github.com/rails/jbuilder), etc..
In order to use one or more of them, be sure to include the corresponding gem into your `Gemfile` and require the library.

Please note that some engines may require [Node.js](https://nodejs.org/en).

### EcmaScript 6

We strongly suggest to use [EcmaScript 6](http://es6-features.org/) for your next project.
It is not yet fully [supported](https://kangax.github.io/compat-table/es6/) by browser vendors, but it's the future of JavaScript.

As of today, you need to transpile ES6 code into something understandable by current browsers, which is ES5.
For this purpose we support [Babel](https://babeljs.io). <strike>Make sure to require `'lotus/assets/es6'` to enable it.</strike>

## Sources

Each application under `apps/` in a Lotus project, can have its own set of assets sources.
The default directory is `assets`, for instance `apps/web/assets`.

You can add other directories if you need to vendor assets, eg: `apps/web/vendor/assets`.

## Third Party Gems

Developers can maintain gems that distribute assets for Lotus. For instance `lotus-ember` or `lotus-jquery`.

As a gem developer, you must add one or more paths, where the assets are stored inside the gem.

```ruby
# lib/lotus/jquery.rb
Lotus::Assets.sources << '/path/to/jquery'
```

## Deployment

This release will ship with a new command: `lotus assets precompile`; which can be used to at the deploy time.

Assets are loaded from the sources of each application (including third party gems) and preprocessed or copied into the public directory of the project.

Each asset is compressed using <strike>[YUI Compressor](http://yui.github.io/yuicompressor) (which requires **Java 1.4+**)</strike> one of the supported engines: YUI, UglifyJS2, Google Closure, Sass.
With this step we shrink the file size, to let browser to download them faster.

As last step, we produce another version of the same file that includes the checksum of the assets in the name (see the example below).
With this trick, we ensure that browsers will always cache the right version of a given asset.

Example:

```erb
<%= javascript 'application' %>
```

```html
<script src="/assets/application-d1829dc353b734e3adc24855693b70f9.js" type="text/javascript"></script>
```

### Heroku

Assets precompilation just works with Heroku.
We introduced private Rake tasks to make sure that Lotus can be easily deployed.

Now in just **5 minutes** you can generate a new project and deploy it!

### No Bundling

We **don't bundle** together all the assets in one gigantic output file.
There are a few reasons for this. First of all, **simplicity**.

Bundling together dozens of assets, would require a complex dependency system that **slows down your deploys**.

It also demands you to maintain the dependencies between assets.
With Lotus design, you just "_require_" assets by adding them to the markup.
If your `users.js` depends on jQuery, you do: `<%= javascript 'jquery', 'users' %>` and that's it.

There also another reason for not bundling them togheter: **HTTP/2**.
This new version of the protocol is already supported by most popular browsers and it will be shipped soon with Nginx.

This changes the way client and server communicate over the wire.
Connections will be more efficient with the usage of socket multiplexing.

When we have one huge asset for all the javascripts of our application, this output file will change often.
For each modification in development, we need to recompile it in production.

This action invalidates the old version of `application-ad414f0188b91004debebbe5df37ca05.js`, because it contains stale data.
So we need to generate a new version, let say `application-d1829dc353b734e3adc24855693b70f9.js`.

At this point the application uses this new file and the browser gets the entire file from scratch.
Even for a small change, we're forcing the client to download kilobytes or even megabytes of unmofified javascript code.

With HTTP/2 it's more efficient to keep small files and let the browser to download only stale resources.

So why build a slow and complex dependency system that will be soon useless because of HTTP/2?

## Content Delivery Networks (CDN)

Lotus allows to serve assets via a Content Delivery Network.
What you need to do, is to specify the CDN URL to the application and then the helpers will return the CDN absolute URL for an asset.

```erb
<%= javascript 'application' %>
```

```html
<script src="https://123.cloudfront.net/assets/application-d1829dc353b734e3adc24855693b70f9.js" type="text/javascript"></script>
```

## Release Date

All these features can be used with Lotus full stack applications starting from `v0.6.0`, that will be released on **Jan 12th, 2016**.
If you can't wait, try it with [master branch](https://github.com/lotus/lotus) and let us to know!

<div style="display: inline">

  <iframe src="https://ghbtns.com/github-btn.html?user=lotus&repo=lotus&type=star&count=true&size=large" frameborder="0" scrolling="0" width="160px" height="30px"></iframe>

  <a href="https://news.ycombinator.com/submit" class="hn-button" data-title="Introducing Assets for Lotus (Ruby)" data-url="http://lotusrb.org/blog/2015/12/29/introducing-assets.html" data-count="horizontal" data-style="facebook">Vote on Hacker News</a>
  <script type="text/javascript">var HN=[];HN.factory=function(e){return function(){HN.push([e].concat(Array.prototype.slice.call(arguments,0)))};},HN.on=HN.factory("on"),HN.once=HN.factory("once"),HN.off=HN.factory("off"),HN.emit=HN.factory("emit"),HN.load=function(){var e="hn-button.js";if(document.getElementById(e))return;var t=document.createElement("script");t.id=e,t.src="//hn-button.herokuapp.com/hn-button.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(t,n)},HN.load();</script>
  <script type="text/javascript">
    reddit_url = "http://lotusrb.org/blog/2015/12/21/announcing-lotus-assets.html";
  </script>
  <script type="text/javascript" src="//www.redditstatic.com/button/button1.js"></script>
</div>
