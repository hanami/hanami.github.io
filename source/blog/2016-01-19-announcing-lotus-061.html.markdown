---
title: Announcing Lotus v0.6.1
date: 2016-01-19 8:48 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Minor fixes for CLI, cookie sessions and database exceptions.
---

This is a patch release that addresses some bugs reported after [v0.6.0 release](/blog/2016/01/12/announcing-lotus-060.html).

## Bug Fixes

### lotusrb [v0.6.1](https://github.com/lotus/lotus/blob/master/CHANGELOG.md#v061---2016-01-19)

  - Show the current app name in Welcome page (eg. `/admin` shows instructions on how to generate an action for `Admin` app) [[Anton Davydov](https://github.com/davydovanton)]
  - Fix project creation when name contains dashes (eg. `"awesome-project" => "AwesomeProject"`) [[Anton Davydov](https://github.com/davydovanton)]
  - Ensure to add assets related entries to `.gitignore` when a project is generated with the `--database` flag [[Anton Davydov](https://github.com/davydovanton)]
  - Avoid blank lines in generated `Gemfile` [[deepj](https://github.com/deepj)]
  - Fix for `lotus destroy app`: it doesn't cause a syntax error in `config/application.rb` anymore [[trexnix](https://github.com/trexnix)]
  - Ensure console to use the bundled engine [[Serg Ikonnikov](https://github.com/sergikon) &amp; [Trung Lê](https://github.com/joneslee85)]

### lotus-utils [v0.6.1](https://github.com/lotus/utils/blob/master/CHANGELOG.md#v061---2016-01-19)

  - Ensure `Lotus::Utils::String#classify` to work properly with dashes (eg. `"app-store" => "App::Store"`) [[Anton Davydov](https://github.com/davydovanton)]

### lotus-router [v0.5.1](https://github.com/lotus/router/blob/master/CHANGELOG.md#v051---2016-01-19)

  - Print stacked lines for routes inspection [[Anton Davydov](https://github.com/davydovanton)]

### lotus-controller [v0.5.1](https://github.com/lotus/controller/blob/master/CHANGELOG.md#v051---2016-01-19)

  - Ensure `rack.session` cookie to not be sent twice when both `Lotus::Action::Cookies` and `Rack::Session::Cookie` are used together [[Alfonso Uceda](https://github.com/AlfonsoUceda)]

### lotus-model [v0.5.2](https://github.com/lotus/model/blob/master/CHANGELOG.md#v052---2016-01-19)

  - Improved error message for `Lotus::Model::Adapters::NoAdapterError` [[Sean Collins](https://github.com/cllns)]
  - Catch Sequel exceptions and re-raise as `Lotus::Model::Error` [[Kyle Chong](https://github.com/Moratorius) &amp; [Trung Lê](https://github.com/joneslee85)]

## Upgrade Instructions

In order to get these bug fixes, just run `bundle update` from the root of the project.

<div style="display: inline">

  <iframe src="https://ghbtns.com/github-btn.html?user=lotus&repo=lotus&type=star&count=true&size=large" frameborder="0" scrolling="0" width="160px" height="30px"></iframe>

  <a href="https://news.ycombinator.com/submit" class="hn-button" data-title="Announcing Lotus v0.6.1" data-url="http://lotusrb.org/blog/2016/01/19/announcing-lotus-061.html" data-count="horizontal" data-style="facebook">Vote on Hacker News</a>
  <script type="text/javascript">var HN=[];HN.factory=function(e){return function(){HN.push([e].concat(Array.prototype.slice.call(arguments,0)))};},HN.on=HN.factory("on"),HN.once=HN.factory("once"),HN.off=HN.factory("off"),HN.emit=HN.factory("emit"),HN.load=function(){var e="hn-button.js";if(document.getElementById(e))return;var t=document.createElement("script");t.id=e,t.src="//hn-button.herokuapp.com/hn-button.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(t,n)},HN.load();</script>
  <script type="text/javascript">
    reddit_url = "http://lotusrb.org/blog/2016/01/19/announcing-lotus-061.html";
  </script>
  <script type="text/javascript" src="//www.redditstatic.com/button/button1.js"></script>
</div>
