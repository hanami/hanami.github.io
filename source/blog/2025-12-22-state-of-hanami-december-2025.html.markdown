---
title: State of Hanami, December 2025
date: 2025-12-22 12:30:00 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  Everything we did in 2025, and our plans for 2026.
---

# State of Hanami, December 2025

I’m very pleased to share our **State of Hanami** update for 2025! We’re back for our second time. If you want to get caught up, [check out our update from last year](https://hanamirb.org/blog/2024/12/10/state-of-hanami-december-2024/).

This has been a pivotal year for Hanami, our first steps into a new era: we made a substantial new release, began unifying our ecosystem, expanded our team, launched our sponsorship program, and saw a real uptick in community activity.

I’ll go into all these highlights below, before leaving you with some plans for 2026.

## Our biggest release yet

In November we [released Hanami 2.3](https://hanamirb.org/blog/2025/11/12/hanami-23-racked-and-ready/). This was our first major release in a year, and it turned out to be our biggest release yet, with 32 different contributors choosing to make Hanami better. Hanami 2.3 introduced Rack 3 support, resource routing, improved media type handling, along with a wide range of DX improvements. We’d love for you to give it a try!

## Our ecosystem came together

Our maintainers this year have been taking care of [Dry](https://dry-rb.org) and [Rom](https://rom-rb.org) in addition to Hanami. We’ve been working towards bringing these projects together under a single banner. As part of this, we’ve chosen a new overall project name, and have been developing a new website and unified branding. Together, these will reintroduce us to the Ruby world and give our users an easier time learning our tools. We plan to launch these in February, but in the meantime, you can check out the [source code](https://github.com/hanakai-rb/site) and the [in-progress](https://hanakai.org) live site (our guides are already [looking particularly fine](https://hanakai.org/learn/hanami/v2.3/getting-started)).

## Our team grew again

This year we welcomed nine new people to our maintainers team:

- [Aaron Allen](https://github.com/aaronmallen)
- [Andrea Fomera](https://github.com/afomera)
- [Damian C. Rossney](https://github.com/dcr8898)
- [Josephine Hall](https://github.com/josephinehall)
- [Krzysztof Piotrowski](https://github.com/krzykamil)
- [Max Wheeler](https://github.com/makenosound)
- [Paweł Świątkowski](https://github.com/katafrakt)
- [Ryan Bigg](https://github.com/radar)
- [Sven Schwyn](https://github.com/svoop)

These joined our existing team members, who have continued to work over the last year:

- [Aaron Moodie](https://github.com/aaronmoodie)
- [Adam Lassek](https://github.com/alassek)
- [Kyle Plump](https://github.com/kyleplump)
- [Marc Busqué](https://github.com/waiting-for-dev)
- [Nikita Shilnikov](https://github.com/flash-gordon)
- [Philip Arndt](https://github.com/parndt)
- [Sean Collins](https://github.com/cllns)
- [Tim Riley](https://github.com/timriley)

Thank you to all these beautiful people for giving their time to Hanami and for improving our part of the Ruby world!

All up, our maintainers team is now 17 strong. This feels like a good foundation for us to step up and do even better work next year. If you’d like to get involved, we recommend helping to triage issues and evaluate pull requests.

## Our community shone through

Our community took things to a new level this year:

* We launched [our Discord](https://discord.gg/KFCxDmk3JQ) and saw it bring more community activity than ever before.
* We saw the launch of several new open source Hanami apps, including Princeton University Library’s [orcid\_princeton\_hanami](https://github.com/pulibrary/orcid_princeton_hanami), which is also running in production! Huge props to [Carolyn Cole](https://github.com/carolyncole) for driving that project and [sharing her thoughts](https://discourse.hanamirb.org/t/converting-a-rails-app-feature-parity/1287) on the process. We also saw the release of Pat Allan’s [Playsmith](https://codeberg.org/patallan/playsmith), Ryan Bigg’s [Twist v3](https://github.com/radar/twist-v3), and our very own [upcoming website](https://github.com/hanakai-rb/site). Meanwhile, Paweł continues to keep [Palaver](https://github.com/katafrakt/palaver) up to date as one of the most complete example apps out there.
* [Edouard](https://github.com/inouire) launched the new (commercial) [Catalogue Studio](https://catalogue-studio.com/), after leaving us a brilliant trail of “[Tips and notes about \[his\] journey](https://discourse.hanamirb.org/t/hanami-1-3-hanami-2-2-tips-notes-about-my-journey/1210)” from Hanami 1.3 to 2.2.
* [Andrea Fomera](https://github.com/afomera) arrived on the scene with a *meteorological* level of energy. She contributed some key pieces to Hanami 2.3, and also created [hanami-omakase](https://github.com/afomera/hanami-omakase) as a proving ground for Rails-alike features.
* [Ryan Bigg](https://github.com/radar) pointed his big blogging brain our way and penned his “[Hanami for Rails developers](https://ryanbigg.com/2025/10/hanami-for-rails-developers-1-models)” series. With Ryan now on the team, we’re looking forward to creating our very own “for Rails devs” guides in the future!
* [Andrew Nesbitt](https://github.com/andrew) shipped [hanami-sprockets](https://github.com/andrew/hanami-sprockets), an alternative asset bundler and proving ground for the pluggable bundlers we’d like to ship next year.
* Andrew also helped us get our new [awesome-hanakai](https://github.com/hanakai-rb/awesome-hanakai) repo off the ground. There’s still a bit of tidying to do, but it exists, and that’s the important thing. If you have something awesome, now you know where to put it!
* Did I mention our Hanami 2.3 release saw input from 32 different contributors? This is amazing! Thanks in particular to [Wout](https://github.com/wout) and [Armin](https://github.com/wuarmin) for multiple helpful contributions across the year.
* Starting in August, I’ve also been sharing [my weeknotes](https://timriley.info/tag/continuations) covering Hanami development. I hope you find them helpful!

Our community is the most important thing to us. To reflect this, this year we made our community values clearer than ever, and placed them [front and centre on our website](https://hanamirb.org):

> We want the Hanami community to be a welcoming place for people who bring kindness, curiosity, and care. A place where people of all backgrounds and experience levels can feel respected, and can share and grow. A place for people to be proud of, and feel safe within.
>
> We do not tolerate nazis, transphobes, racists, or any kind of bigotry. See our [code of conduct](https://hanamirb.org/community#code-of-conduct) for more.

We also [adopted the Contributor Covenant 3.0](https://hanamirb.org/blog/2025/09/02/hanami-adopts-contributor-covenant-3-0/), which brings a more approachable text for our worldwide community, and places a helpful emphasis on restorative justice.

I believe our values have played a big part in the health and growth of our community this year. Thank you to everyone for building a space we can all enjoy!

## We went out into the world

Once again, we took ourselves to some conferences!

* Tim visited beautiful Riga, Latvia for [Baltic Ruby](https://balticruby.org/archive/2025), where he presented a new Murakami-themed introduction to Hanami, and thoughts on the importance of a diverse Ruby ecosystem. He also ran a hack session, where [Ismael Celis](https://github.com/ismasan) used his [sourced](https://github.com/ismasan/sourced) toolkit to create the [world’s first event-sourced calculator built on Hanami](https://bsky.app/profile/ismaelcelis.com/post/3lrj5ltfvlc2a), and [Krzysztof](https://github.com/krzykamil) worked on the `db rollback` command for Hanami 2.3. Thank you to Baltic Ruby for the invitation!
* [Sean](https://github.com/cllns) attended [Rocky Mountain Ruby](https://rockymtnruby.dev) in Boulder, Colorado, and spoke on [Slicing and Dicing through Complexity with Hanami](https://www.rubyevents.org/talks/slicing-and-dicing-through-complexity-with-hanami?back_to=%2Fevents%2Frocky-mountain-ruby-2025%2Ftalks%3Fscroll_top%3D1872&back_to_title=Rocky+Mountain+Ruby+2025). He also got to spend some quality time with some #HanamiFriends new and old!
* Tim was lucky enough to reprise his talk at both [XO Ruby San Diego](https://www.xoruby.com/event/san-diego/) and [thoughtbot Open Summit](https://thoughtbot.com/blog/announcing-the-thoughtbot-open-summit-2025-full-schedule). Thanks to XO organiser [Jim Remsik](https://ruby.social/@jremsikjr), the San Diego talk was streamed to the internet, and the Open Summit was a native online event. We saw a good-sized group come together for each one, and I’m really glad I could share Hanami in such an open way. Thank you to Jim and thoughtbot for making these happen!

<div style="display: flex; gap: 1rem;">
<img src="/blog/2025/12/22/state-of-hanami-december-2025/sean-at-rocky-mountain-ruby.jpeg" alt="Sean on stage at Rocky Mountain Ruby" style="flex: 1; max-width: 50%;">
<img src="/blog/2025/12/22/state-of-hanami-december-2025/tim-at-baltic-ruby.jpeg" alt="Matz joins the Hanami table at Baltic Ruby" style="flex: 1; max-width: 50%;">
</div>

## We launched our sponsorship program

This year we launched our first ever [sponsorship program](https://sponsor.hanamirb.org) for Hanami, Dry and Rom. These are big and ambitious projects, and they need consistent attention for them to grow. Thanks to the support of the Ruby community, we made this happen! Since February this year, I’ve been able to commit a full business day every week towards the stewardship of our projects.

This could not have happened without our founding patrons. Thank you to [**Sidekiq**](https://sidekiq.org/), [**Brandon Weaver**](https://github.com/baweaver), [**Honeybadger**](https://www.honeybadger.io/?utm_source=hanami&utm_medium=paid-referral&utm_campaign=founding-patron), [**FastRuby**](https://www.fastruby.io/), and [**AppSignal**](https://www.appsignal.com/) for your support! Your courage and belief is what got this thing off the ground in the first place.

Thank you also to all the individuals who are supporting us [through GitHub sponsors](https://github.com/sponsors/hanami). There are 20 of you right now! There’s real power in numbers, and your support takes us further than we could go alone.

We’ll run another sponsorship drive toward the middle of next year, but we are ready to accept your support at any time! [See our sponsorship site](https://sponsor.hanamirb.org) to learn more. A few more businesses, or growing from 20 to 40 individual supporters, would make a huge difference to our project. And as you can see from everything in this post, your support goes a long way.

We have also ceased our relationship with Ruby Central as a fiscal host, following their removal of the Bundler and RubyGems.org maintainer teams from those projects, and their conduct thereafter. We stand with every maintainer.

## Looking forward to next year

Just like [last year](https://hanamirb.org/blog/2024/12/10/state-of-hanami-december-2024/), we have some goals we want to pursue across 2026:

* **Establish a twice-a-year release cycle for Hanami.** Right now we’re aiming for May and November.
* **Finish unifying our ecosystem.** We’ll launch our new site, finish rolling out our repo sync and release automation, then look at merging our forums.
* **Prepare the future for Dry and Rom.** We want to reinvigorate these gems and make things easier for new contributors. This means triaging issues, bringing on focused maintainers, and developing roadmaps for the next phase of these projects.
* **Enter a successful second year of funded maintenance.** Year one proved we could do this. Year two will show us whether we can sustain it. We’re looking forward to your support!

We’ll share more on each of these as we work through the year.

In the meantime, that’s it from us for 2025. Thank you to everyone who contributed to a wonderful year of improvements. We’re looking forward to continuing the work!
