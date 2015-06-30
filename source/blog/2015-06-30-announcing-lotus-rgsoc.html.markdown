---
title: Announcing Rails Girls Summer of Code x Lotus
date: 2015-06-30 08:23 UTC
tags: announcements
author: Trung Lê
image: true
excerpt: >
  This year marks the first participitation of Lotus project
  with Rails Girls Summer of Code program to deliver the long
  awaited mailer feature that has been set to be released
  along the roadmap for version 0.5.0.
---

Hello our beloved Community.

We are thrilled to announce Lotus's very first participation
with [Rails Girls Summer of Code](http://railsgirlssummerofcode.org).

Rails Girls Summer of Code is a 3 months program scholarship for
female students to take part in OSS projects and this year marks
the 3rd year of the program.

As the projector mentor this year, I would like to extend welcome to Inês & Rosa of Team DEIGirls from Coimbra, Portugal. For the next
3 months, I'll be following our girls' every step to bring to our
Community the long awaited **mailer** feature.

Mailer feature is planned to be released along with our Lotus 0.5.0
as we've announced in our [roadmap post](https://discuss.lotusrb.org/t/lotus-v0-5-0-roadmap/95) yesterday. Following our philosophy, mailer library will be delivered as [lotus-mailer](https://github.com/lotus/mailer) gem that can be utilised with any existing Ruby applications, and at the same time as an integrated component of Lotus applications.

Let's see what `lotus-mailer` has to offer. The library will use the battle-tested [mail](https://github.com/mikel/mail) gem by my fellow Aussie [Mikel Lindsaar](https://github.com/mikel). It will offer ability to customising templates, supporting many delivery methods and attachments. Furthermore, Lotus would leverage `lotus-model` to deliver mail based on 1:1 association between mailer and the usecase, unlike those of multiple usecases of Rails (a mailer could do multiple messages, eg. welcome users, forgot password, etc).

Again, a big shout out to awesome Rails Girls Summer of Code team and to our coach Christian Weyer.

Please leave your comment of support for our girls this summer :)

Peace out
