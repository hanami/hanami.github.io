---
title: Announcing Hanami v1.0.0
date: 2017-04-06 07:46 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Hanami v1.0.0 🎉
---

## One-Point-OOOh! 😱

Hanami is a full-stack, lightweight, yet powerful web framework for Ruby.

Back in the summer of 2012, as a frustrated web developer, I started an experiment to _rethink_ Ruby on Rails and to build a modern web framework for Ruby.
The goal was to keep all what I consider the good parts of Rails and to add extra components to ease long term maintenance and testability.

The experiment was promising, and I eventually started to open source Hanami at the beginning of 2014.

Since then, it's been amazing journey. I have learned a lot about Ruby, Open Source, and people.
The community aspect of this experience is key to me. Software is made by people for people.
It's political. Hanami is a consequence of my vision: I, **we**, want to include people, keep them motivated to work on Open Source, and have fun together.

This goes beyond Hanami. Alongside with other projects like [ROM](http://rom-rb.org/), [dry-rb](http://dry-rb.org/), and [Trailblazer](http://trailblazer.to/) we're influencing how modern web applications are written with Ruby.

**After 1392 days, 6205 commits, made by 295 people, we're proud to announce Hanami 1.0.0! 🌸**

A huge thank you goes to [all of the people who contributed](http://contributors.hanamirb.org/) in all these years. 💚💙💛❤️

## Core Team

Open Source doesn't mean just _"open code"_. Above all, it means an open decision process.
Today marks a change in the governance of Hanami: we'll now have a diverse team to make decisions about the future of the project, together.

I'm excited to announce an expansion of the [core team](/team), by adding marvellous new people I've met during these years:

<div class="container-fluid">
  <div class="row my-4">
    <div class="col-sm-6">
      <ul class="featured-list featured-list-bordered">
        <li>
          <div class="featured-list-icon">
            <img class="team-avatar" src="https://avatars2.githubusercontent.com/u/1147484?v=3&s=460">
          </div>

          <h3><a href="https://twitter.com/anton_davydov">Anton Davydov</a></h3>
          <p>Saint Petersburg, Russia</p>
        </li>

        <li>
          <div class="featured-list-icon">
            <img class="team-avatar" src="https://avatars2.githubusercontent.com/u/248372?v=3&s=460">
          </div>

          <h3><a href="https://twitter.com/TiteiKo">Marion Duprey</a></h3>
          <p>Paris, France</p>
        </li>

        <li>
          <div class="featured-list-icon">
            <img class="team-avatar" src="https://avatars0.githubusercontent.com/u/3356996?v=3&s=460">
          </div>

          <h3><a href="https://twitter.com/oanasipos">Oana Sipos</a></h3>
          <p>Cluj-Napoca, Romania</p>
        </li>
      </ul>
    </div>
    <div class="col-sm-6">
      <ul class="featured-list featured-list-bordered">
        <li>
          <div class="featured-list-icon">
            <img class="team-avatar" src="https://avatars2.githubusercontent.com/u/632942?v=3&s=460">
          </div>

          <h3><a href="https://twitter.com/seancllns">Sean Collins</a></h3>
          <p>Boulder, United States</p>
        </li>

        <li>
          <div class="featured-list-icon">
            <img class="team-avatar" src="https://avatars2.githubusercontent.com/u/10281?v=3&s=460">
          </div>

          <h3><a href="https://twitter.com/mereghost">Marcello Rocha</a></h3>
          <p>Sao Paulo, Brazil</p>
        </li>

        <li>
          <div class="featured-list-icon">
            <img class="team-avatar" src="https://avatars2.githubusercontent.com/u/5722022?v=3&s=460">
          </div>

          <h3><a href="https://twitter.com/rubydwarf">Marion Schleifer</a></h3>
          <p>Zurich, Switzerland</p>
        </li>
      </ul>
    </div>
  </div>
</div>
<br>
Along with [Alfonso Uceda](https://twitter.com/joshka20) (already a member), we'll work on the future of Hanami.

## Released Gems

  * `hanami-1.0.0`
  * `hanami-model-1.0.0`
  * `hanami-utils-1.0.0`
  * `hanami-validations-1.0.0`
  * `hanami-router-1.0.0`
  * `hanami-controller-1.0.0`
  * `hanami-view-1.0.0`
  * `hanami-helpers-1.0.0`
  * `hanami-mailer-1.0.0`
  * `hanami-assets-1.0.0`

## How To Get Started

If you're new to Hanami, we prepared a [guide](/guides/getting-started) to build and deploy your very first project.

## How To Upgrade

Edit your `Gemfile`:

```ruby
gem 'hanami',       '~> 1.0'
gem 'hanami-model', '~> 1.0'
```

Then run `bundle update hanami hanami-model`.

If you're upgrading from `v0.9.x`, please check the [upgrade guide](/guides/upgrade-notes/v100) for `v1.0.0`.

## What's Next?

We're already shaping the future of the project and what goes in the next version (`v1.1.0`).
If you care about Hanami and want to share your ideas, please join [our conversation](https://discourse.hanamirb.org/t/hanami-2-0-ideas/306).

**But for today, thank you all for this amazing journey.**

🌸
