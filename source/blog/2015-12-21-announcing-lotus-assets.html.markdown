---
title: Announcing Lotus::Assets
date: 2015-12-21 16:13 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Announcing Lotus::Assets as a powerful and fast assets management for Lotus.
---

After one year of development, we're proud to announce the latest framework in the Lotus toolkit: `lotus-assets`.
It's a new gem that offers powerful assets management for Lotus and Ruby web applications.


## Features

### Helpers

This framework offers assets specific helpers to be used in templates.
They resolve one or multiple sources into corresponding HTML tags.
Those sources can be the name of the local asset or an absolute URL.

Given the following template:

```erb
<!doctype HTML>
<html>
  <head>
    <title>Assets example</title>
    <%= stylesheet 'reset', 'grid', 'main' %>
  </head>

  <body>
  <!-- ... -->
  <%= javascript 'https://code.jquery.com/jquery-2.1.1.min.js', 'application' %>
  <%= javascript 'modals' %>
  </body>
</html>
```

It will output this markup.

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
  <script src="https://code.jquery.com/jquery-2.1.1.min.js" type="text/javascript"></script>
  <script src="/assets/application.js" type="text/javascript"></script>
  <script src="/assets/modals.js" type="text/javascript"></script>
  </body>
</html>
```

Helpers are available **both in templates and views**.

#### Available Helpers

It ships with the following helpers:

  * `javascript`
  * `stylesheet`
  * `favicon`
  * `image`
  * `video`
  * `audio`
  * `asset_path`
  * `asset_url`

### Preprocessors

`Lotus::Assets` is able to run assets preprocessors and **lazily compile** them
under `public/assets` (by default).

Imagine to have `main.css.scss` under `apps/web/assets/stylesheets` and `reset.css` under
`apps/web/vendor/assets/stylesheets`.

**The extensions structure is important.**
The first one is mandatory and it's used to understand which asset type we are
handling: `.css` for stylesheets.
The second one is optional and it's for a preprocessor: `.scss` for Sass.

When from a template you do:

```erb
<%= stylesheet 'reset', 'main' %>
```

After the preprocessor is done, your public directory will have the following structure.

```shell
% tree public
public/
└── assets
    ├── reset.css
    └── main.css
```

#### Preprocessors engines

`Lotus::Assets` uses [Tilt](https://github.com/rtomayko/tilt) to provide support for the most common preprocessors, such as [Sass](http://sass-lang.com/) (including `sassc-ruby`), [Less](http://lesscss.org/), ES6, [JSX](https://jsx.github.io/), [CoffeScript](http://coffeescript.org), [Opal](http://opalrb.org), [Handlebars](http://handlebarsjs.com), [JBuilder](https://github.com/rails/jbuilder).

In order to use one or more of them, be sure to include the corresponding gem into your `Gemfile` and require the library.

Please note that some engines may require [Node.js](https://nodejs.org/en/).

##### EcmaScript 6

We strongly suggest to use [EcmaScript 6](http://es6-features.org/) for your next project.
It isn't fully [supported](https://kangax.github.io/compat-table/es6/) yet by browser vendors, but it's the future of JavaScript.

As of today, you need to transpile ES6 code into something understandable by current browsers, which is ES5.
For this purpose we support [Babel](https://babeljs.io). Make sure to require `'lotus/assets/es6'` to enable it.

### Deployment

The upcoming version of Lotus (`v0.6.0`) will ship with a new command `lotus assets precompile`, which can be used to precompile assets, compress and make them cacheable by browsers (via digest suffix).

Compression algorithm is based on [YUI Compressor](http://yui.github.io/yuicompressor), which requires Java 1.4+.

### Digest Mode

This is a mode that can be activated via the configuration and it's suitable for production environments.

Once turned on, it will look at `public/assets.json`, and helpers such as `javascript` will return a relative URL that includes the digest of the asset.

```erb
<%= javascript 'application' %>
```

```html
<script src="/assets/application-d1829dc353b734e3adc24855693b70f9.js" type="text/javascript"></script>
```

### CDN Mode

Once activated, helpers will return the CDN absolute URL for the asset.

```erb
<%= javascript 'application' %>
```

```html
<script src="https://123.cloudfront.net/assets/application-d1829dc353b734e3adc24855693b70f9.js" type="text/javascript"></script>
```

### Third Party Gems

Developers can maintain gems that distribute assets for Lotus. For instance `lotus-ember` or `lotus-jquery`.

As a gem developer, you must add one or more paths, where the assets are stored inside the gem.

```ruby
# lib/lotus/jquery.rb
Lotus::Assets.sources << '/path/to/jquery'
```

## Release Date

`lotus-assets` will be relased as `v0.1.0` with the upcoming release of `lotusrb-0.6.0`. In the meantime, you can try it with Lotus master.

<div style="display: inline">

  <iframe src="https://ghbtns.com/github-btn.html?user=lotus&repo=lotus&type=star&count=true&size=large" frameborder="0" scrolling="0" width="160px" height="30px"></iframe>

  <a href="https://news.ycombinator.com/submit" class="hn-button" data-title="Announcing Lotus::Assets" data-url="http://lotusrb.org/blog/2015/12/21/announcing-lotus-assets.html" data-count="horizontal" data-style="facebook">Vote on Hacker News</a>
  <script type="text/javascript">var HN=[];HN.factory=function(e){return function(){HN.push([e].concat(Array.prototype.slice.call(arguments,0)))};},HN.on=HN.factory("on"),HN.once=HN.factory("once"),HN.off=HN.factory("off"),HN.emit=HN.factory("emit"),HN.load=function(){var e="hn-button.js";if(document.getElementById(e))return;var t=document.createElement("script");t.id=e,t.src="//hn-button.herokuapp.com/hn-button.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(t,n)},HN.load();</script>
  <script type="text/javascript">
    reddit_url = "http://lotusrb.org/blog/2015/12/21/announcing-lotus-assets.html";
  </script>
  <script type="text/javascript" src="//www.redditstatic.com/button/button1.js"></script>
</div>
