---
title: Lotus is now Hanami
date: 2016-01-22 14:54 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Lotus is now Hanami
---

## Lotus

More than three years ago I started hacking with this tiny web framework.
Naming is hard, as you know, and the choice felt on something that has a deep meaning for me: **Lotus**.

### The Origins

I was aware of the famous IBM's office suite, but I thought it was something belonging to the past and would have never expected Lotus (my Lotus) to become known in Ruby ecosystem.
Now, this name collision has caused minor confusion outside of Ruby Community.
HackerNews or [ThoughtWork's Radar](https://www.thoughtworks.com/radar/languages-and-frameworks/lotus) are clear examples.
There always been the need to specify Lotus for Ruby.

### The Problem

It wasn't a huge problem until a few weeks ago.
We received [an issue on GitHub](https://github.com/hanami/hanami/issues/445) from an IBM employee, who informally made us to notice about the fact that they hold the trademark in software industry for Lotus.
That was the first warning that I could've been sued in the future by them.

### The Decision

In the subsequent two weeks, I've talked with our Community, with a lawyer and the decision is to change the name.

I want to clarify that I never received a letter by IBM, it's only a strategic choice.
First of all, the word "Lotus" is too much popular and it always been hard for me to track online discussions.

Secondly, sharing the same name will always be source of confusion for developers.
Better to find a new name: **Hanami**.

## Hanami

Hanami is a japanese tradition of watching the cherry trees to blossom during spring.
During this season, they celebrate this event all together in their beautiful gardens.

This choice remarks a continuity with the past of the project and it also puts a strong emphasis on **the importance that our Community has for us**.

**This is also a tribute to Matz and Ruby origins.**

### New Website

The new website is [http://hanamirb.org](http://hanamirb.org), and you can find us on Twitter as [@hanamirb](https://twitter.com/hanamirb) ([#hanamirb](https://twitter.com/search?f=tweets&vertical=default&q=hanamirb)).
We moved the source code at [https://github.com/hanami](https://github.com/hanami).

The main Ruby gem is now [`hanami`](https://rubygems.org/gems/hanami).

### Gem Releases

In order to reflect this reorganization, we release today all the gems under the new name.
We bumped the minor version because this is a breaking change.

  * `hanami-0.7.0` (equivalent to `lotusrb-0.6.1`)
  * `hanami-utils-0.7.0` (equivalent to `lotus-utils-0.6.1`)
  * `hanami-validations-0.5.0` (equivalent to `lotus-validations-0.4.0`)
  * `hanami-router-0.6.0` (equivalent to `lotus-router-0.5.1`)
  * `hanami-helpers-0.3.0` (equivalent to `lotus-helpers-0.2.6`)
  * `hanami-model-0.6.0` (equivalent to `lotus-model-0.5.2`)
  * `hanami-view-0.6.0` (equivalent to `lotus-view-0.5.0`)
  * `hanami-controller-0.6.0` (equivalent to `lotus-controller-0.5.1`)
  * `hanami-assets-0.2.0` (equivalent to `lotus-assets-0.1.0`)
  * `hanami-mailer-0.2.0` (equivalent to `lotus-mailer-0.1.0`)

### Upgrade Notes

Please read the [upgrade notes for v0.7.0](/guides/upgrade-notes/v070) in our Guides.
