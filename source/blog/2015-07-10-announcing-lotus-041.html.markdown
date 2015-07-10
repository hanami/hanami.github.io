---
title: Announcing Lotus v0.4.1
date: 2015-07-10 17:16 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Lotus patch release: Fix container routes, Rack middleware sessions and CLI commands.
---

## Fixes

This patch release ships only with bug fixes.
Thanks to all our contributors who have reported and fixed issues.

### Container Architecture Routes

[Thiago Felippe](https://github.com/theocodes) and [Alfonso Uceda](https://github.com/AlfonsoUceda) fixed duplicated route segments for applications mounted in [Lotus Container](/guides/architectures/container).

The following configuration was generating the `/admin` prefix twice:  `/admin/admin/dashboard` instead of `/admin/dashboard`.

```ruby
Lotus::Container.configure do
  mount Admin::Application, at: `/admin`
end
```

### Database Creation for PostgreSQL

[Nick Coyne](https://github.com/nickcoyne) fixed database creation for PostgreSQL.
It now uses `createdb` when we do `lotus db create`.

### Explicit Partial Search

[Farrel Lifson](https://github.com/farrell) suggested a patch to force explicit partial finding in case of name clash.

### Apps In Console

[Alfonso Uceda](https://github.com/AlfonsoUceda) fixed application loading in `lotus console`

### Session Secret

[Alfonso Uceda](https://github.com/AlfonsoUceda) fixed generator for [application arch](/guides/architectures/application) to generate session secret

### Generators

[Alfonso Uceda](https://github.com/AlfonsoUceda), [Trung Lê](https://github.com/joneslee85), [Hiếu Nguyễn](https://github.com/hieuk09) and [Miguel Molina](https://github.com/mvader) fixed application and model generators when database name is mispelled or entity name is missing, respectively.

### Session Middleware

I fixed Rack middleware in order to makes sessions available to other Rack components.

## Roadmap For v0.5.0

A few days ago, we have [published the roadmap for v0.5.0](http://bit.ly/lotusrb-roadmap-v050), which is scheduled for **Sep 23, 2015**.
It includes **websockets**, **assets**, **mailers**, **associations** and experimental features.
Please join the discussion and let us to hear your opinion.
Thank you!

<div style="display: inline">
  <iframe src="https://ghbtns.com/github-btn.html?user=lotus&repo=lotus&type=star&count=true&size=large" frameborder="0" scrolling="0" width="160px" height="30px"></iframe>

  <a href="https://news.ycombinator.com/submit" class="hn-button" data-title="Announcing Lotus v0.4.1" data-url="http://lotusrb.org/blog/blog/2015/07/10/announcing-lotus-041.html" data-count="horizontal" data-style="facebook">Vote on Hacker News</a>
  <script type="text/javascript">var HN=[];HN.factory=function(e){return function(){HN.push([e].concat(Array.prototype.slice.call(arguments,0)))};},HN.on=HN.factory("on"),HN.once=HN.factory("once"),HN.off=HN.factory("off"),HN.emit=HN.factory("emit"),HN.load=function(){var e="hn-button.js";if(document.getElementById(e))return;var t=document.createElement("script");t.id=e,t.src="//hn-button.herokuapp.com/hn-button.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(t,n)},HN.load();</script>
  <script type="text/javascript">
    reddit_url = "http://lotusrb.org/blog/blog/2015/07/10/announcing-lotus-041.html";
  </script>
  <script type="text/javascript" src="//www.redditstatic.com/button/button1.js"></script>
</div>
