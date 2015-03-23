---
title: Announcing Lotus v0.3.0
date: 2015-03-23 17:14 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  This is the most exciting Lotus release ever.
  We have new features, improved security, and more real world use cases.
---

## Stability and adoption

Lotus is getting more and more stable. This is the result of real world feedback of products that we are following closely during their development with Lotus.

The first company that we are happy to give a warm welcome in our family is **[DNSimple](https://dnsimple.com)**.
They are [maintaining](https://speakerdeck.com/weppos/maintaining-a-5yo-ruby-project-shark-edition) a rock solid Ruby code base that uses Rails for their flagship product and Lotus for their next HTTP API.

## Security

Security is a vital factor for companies and a sensitive subject for users. A product won't survive if not proven secure.

The Web is an insecure place. As a Community, we need to build a Security culture.
Lotus wants to increase the level of awareness around this topic and provide defense mechanisms to common attacks.

Please remember that **there isn't a silver bullet** when we talk about security. Nearly all protections can be debunked by experienced attackers. Developers should use all the available tools to make hackers' life harder.

### XSS

[XSS](https://www.owasp.org/index.php/Cross-site_Scripting_%28XSS%29) (Cross Site Scripting) is one of the most [popular](https://www.owasp.org/index.php/Top10#OWASP_Top_10_for_2013) threat for web applications. It's caused by unescaped malicious input, often sent with forms. Once the payload is on a web page, it can activate evil scripts to take over the control and eventually steal data (cookies).

As first countermeasure, since now on, the output of views, helpers and presenters is **escaped by default**.

Secondly, cookies will be sent with the `HttpOnly` option turned on. That means JavaScript won't be able to access them via `document.cookie`. If a malign script wants to steal data, it can't because the browser will stop it.

We're not done yet, until we have talked about [Content Security Policy](http://www.html5rocks.com/en/tutorials/security/content-security-policy/) (CSP). It's feature supported by modern browsers to regulate trusted sources of scripts, stylesheets, fonts. It's the ultimate defense against XSS and insecure script execution on the pages. Big products like GitHub, Twitter and GMail are using it. **Lotus is the first Ruby web framework that makes CSP a default**.

### Clickhijacking

It's an [attack](http://en.wikipedia.org/wiki/Clickjacking) that leads users to click on an invisible evil item. The trick is to embed a trusted web page via an iframe, so the user believes to interact with it, but instead their actions are hijacked by a harmful context.

The solution is to send a [HTTP header](https://www.owasp.org/index.php/Clickjacking_Defense_Cheat_Sheet#X-Frame-Options_Header_Types) (`X-Frame-Options`) that regulates which source can embed your web application resources. **Again, Lotus is the first Ruby web framework that enables this defense by default**.

## Features

With this release we have shipped powerful features to make the experience with Lotus more and more frictionless.

### Action generators

While developing a feature that requires an new endpoint, it can be inconvenient to write all the required code by hand. It just breaks the flow.

To solve this problem, we have introduced **a new command line utility**: `lotus generate action`. It produces an action, a view, a template, a route and their related testing code.

### Improved application generator

We have improved the application generator to allow Lotus applications to meet developers' needs.

The command now accepts `--database` command line argument to setup the database of choice. Example `lotus new bookshelf --database=postgresql`.

Another point of extension is the `--test` argument. It generates setup code for Minitest (default) or RSpec. Example `lotus new bookshelf --test=rspec`.

We added the chance to generate an application for existing code base. Think of **a Ruby gem that needs a web UI**, with `lotus new .` it's now possible.

### Database console

As last command line facility, we want to introduce `lotus db console`, a database REPL.

### Helpers

Today we have released a new framework in the Lotus family: `lotus-helpers`. By following our tradition, it's **shipped as a standalone gem** that can be used to enhance views, templates and helpers in Ruby applications, even outside of Lotus.

It delivers a **HTML5 markup generator** and **routing helpers**. On the security front, it brings HTML, HTML attribute and URL **escape functions** that follow OWASP/ESAPI suggestions.

### Additional features

Database transactions, **Interactors**, logger and safe nested param access are only a few of the [features](https://github.com/lotus/lotus/blob/master/FEATURES.md) that are available as of today with 0.3.0.

### Acknowledgments

We want to say thank you to Alfonso Uceda Pompa, Linus Pettersson, Huy Đỗ, Hiếu Nguyễn, Tom Kadwill, Jimmy Zhang, and all the [wonderful people](/community) that are making Lotus a better place every day.

## What's next

We are already developing new functionalities for the next release: database migrations, form helpers, number formatters, CSRF protection and [more](http://bit.ly/lotusrb-roadmap).

<div style="display: inline">
  <iframe src="https://ghbtns.com/github-btn.html?user=lotus&repo=lotus&type=star&count=true&size=large" frameborder="0" scrolling="0" width="160px" height="30px"></iframe>

  <a href="https://news.ycombinator.com/submit" class="hn-button" data-title="Announcing Lotus v0.3.0" data-url="http://lotusrb.org/blog/2015/03/23/announcing-lotus-030.html" data-count="horizontal" data-style="facebook">Vote on Hacker News</a>
  <script type="text/javascript">var HN=[];HN.factory=function(e){return function(){HN.push([e].concat(Array.prototype.slice.call(arguments,0)))};},HN.on=HN.factory("on"),HN.once=HN.factory("once"),HN.off=HN.factory("off"),HN.emit=HN.factory("emit"),HN.load=function(){var e="hn-button.js";if(document.getElementById(e))return;var t=document.createElement("script");t.id=e,t.src="//hn-button.herokuapp.com/hn-button.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(t,n)},HN.load();</script>
</div>
