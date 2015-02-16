---
title: A New Roadmap For Lotus
date: 2015-01-01 13:26 UTC
tags: announcements
author: Luca Guidi
excerpt: >
  Learn from past mistakes, clarify goals, communicate intent, Core Team and priorities such as stability and security.
  This is the new Lotus roadmap.
---

Last year [was great](http://lucaguidi.com/2014/12/23/2014-retrospective-a-year-of-lotus.html), and 2015 brings new challenges to Lotus.

## Learn from mistakes

When I released the first version back in June it was a wild, unexpected success.
There was an uncommon hype for the initial version of a _"yet another web framework for Ruby"_.

Probably, Lotus' vision met the needs of a lot of developers in our Community.
The demand of a rich, stable ecosystem of libraries and patterns to build applications that are dead simple to build and maintain.

But then there was six months of _"communication black-out"_.
All the people whom actively followed the project, were aware that we were making some progress.
This wasn't true for the _"outside world"_, which is made of the rest of the Ruby and tech Community.
For those people, Lotus went out of the radar.

**This was clearly my mistake.**

The result was an unenthusiastic reaction for the last release of December, even if it shipped **long time requested features** like application generator or code reloading.

I've learned that Open Source isn't only about making the code accessible, but it's about **openness**: take collaborative decisions and be transparent.
I have a clear vision for Lotus, but I poorly communicated the idea in the last months.

**Lotus aims to be a complete, lightweight and stable alternative to build web applications with Ruby.**

## Fixing those mistakes

Now that I have clarified the ultimate purpose of the project, how to get there?

We're activating new collaboration channels to serve our goal.
In the making there is **a new website**, where to find **guides** and a **blog** to keep people updated on what's going on.
We're also activating a forum where to **discuss features** and **disclose security alerts**.

Once features are be defined and prioritized for a milestone, you can track the planned, the current and the released functionalities so far.
You can use this [board](http://bit.ly/lotusrb-roadmap) to visualize the progress.

## Core Team

Until now, Lotus was a project which taken the direction that I decided only by myself.
This was useful to move fast at the beginning, to express with code my initial imprint and to lay solid foundations for that idea.

But Lotus is an ambitious project who can't survive with only one individual.
I understood the need of [diversity](https://www.youtube.com/watch?v=YqXU4o24Hkg), and bring real world experiences in the creation process.

Starting from today, [Trung Lê](http://ruby-journal.com) ([@joneslee85](https://github.com/joneslee85)) will be part of the **Lotus Core Team**.
Trung works at [Envato](http://www.envato.com/) and on [Spree Commerce](https://spreecommerce.com/).
In the last months, we have been discussing every day about the direction of Lotus and his tireless dedication made [Lotus::Model](https://github.com/lotus/model) easier to use.
Thank you Trung, welcome aboard.

## Priorities

So far I have talked about communication, open decisions, core team.
Those things are means to a few important values.

### Stability

Lotus relies on _"battle tested"_ libraries like [Tilt](https://github.com/rtomayko/tilt), [Sequel](http://sequel.jeremyevans.net/), [Rack](http://rack.github.io), but it still needs to reach its stability as a software.
To fix blocking issues like bugs or improvements and release patch versions for them, will be our first priority.

During the last year, there was too many people depending on the repository `HEAD`.
This is bad because an application can suddenly break by updating gem dependencies.
We highly recommend to use released versions from [Rubygems](http://rubygems.org/gems/lotusrb).

We're also trying to **avoid** as much as possible **breaking changes** in the public API, even if we're under 1.0.
Continuous, non-backward compatible reorganizations of code, destroy any chance that developers start an ecosystem around a technology.

Think of [Rust](http://www.rust-lang.org/): it's a terrific and innovative language, but nearly nobody uses it.
They kept changing too much, so companies were afraid of invest on it until now.

### Features

The second priority is about features.
We want to ship important functionalities to **improve productivity** and the overall **experience with Lotus**.
Things like migrations, associations, assets management, HTML helpers, HTTP API architecture, will be released in the next months.

### Security

We care about security.
No vital application should be deployed in the wild without a serious assessment about data safety.
Lotus will ship and **activate by default** mechanisms to protect applications and users from the most common attacks like [CSRF](http://en.wikipedia.org/wiki/Cross-site_request_forgery) or [XSS](http://en.wikipedia.org/wiki/Cross-site_scripting).

But there is more: we want to write short guides to **make developers aware of the security measures** that they can use while building applications.

## Conclusion

I hope this will be another outstanding year for Lotus.
Please join us in this journey.
