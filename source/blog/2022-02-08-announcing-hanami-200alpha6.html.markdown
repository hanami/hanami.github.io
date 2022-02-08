---
title: Announcing Hanami v2.0.0.alpha6
date: 2022-02-08 09:28:14 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  [dry-system changes]. Ruby 3.0+ only.
---

Hello Hanami community! We're thrilled to announce the release of Hanami 2.0.0.alpha6!

With this new cycle of monthly based releases we have smaller set of changes, but delivered more frequently.

# [dry-system changes]

This month we focused mainly on the internals of the framework.
The work that Tim Riley is doing is epic.
Hanami 2 is modeled around `dry-system`, which powers the booting process and the dependencies of an app.

[...]

## Ruby 3.0+ only

We took this decision for a clear cut with the past of Ruby.
At the time of the writing (Feb 2022), Ruby 2.6 will reach [End Of Life](https://www.ruby-lang.org/en/downloads/branches/) (EOL) in a month.
It didn't make sense to still support it.

We want further than that, given the opportunity that we have with Hanami 2 to "start fresh" with the Ruby versions to support.
We opted for taking 2.7 out as well.

There are a few inconsistencies that have been fixed in Ruby 3.0.
And we want to get advantage of those.

## What’s included?

Today we’re releasing the following gems:

- `hanami` v2.0.0.alpha6
- `hanami-cli` v2.0.0.alpha6
- `hanami-view` v2.0.0.alpha6
- `hanami-controller` v2.0.0.alpha6
- `hanami-router` v2.0.0.alpha6
- `hanami-utils` v2.0.0.alpha6

## How can I try it?

You can check out our [Hanami 2 application template](https://github.com/hanami/hanami-2-application-template), which is up to date for this latest release and ready for you to use out as the starting point for your own app.

We’d really love for you to give the tires a good kick for this release in this particular: the more real-world testing we can have of our code loading changes, the better!

## What’s coming next?

Thank you as ever for your support of Hanami! We can’t wait to hear from you about this release, and we’re looking forward to checking in with you again next month. 🙇🏻‍♂️🌸
