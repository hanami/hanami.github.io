---
title: Announcing Hanami v1.2.0.beta2
date: 2018-03-23 11:19 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Minor features and bug fixes from <code>v1.2.0.beta1</code>
---

Hello people!

Today we're happy to announce `v1.2.0.beta2` release 🙌 , with the stable release (`v1.2.0`) scheduled for **April 2018**.

## Features 🍎

  * Support objects as CLI callbacks

## Bug fixes 🐛

  * Ensure CLI callbacks' context of execution (aka `self`) to be the command that is being executed
  * Raise meaningful error message when trying to access `session` or `flash` with disabled sessions
  * Print stack trace to standard output when a CLI command raises an error

## Released Gems 💎

  * `hanami-1.2.0.beta2`
  * `hanami-model-1.2.0.beta2`
  * `hanami-assets-1.2.0.beta2`
  * `hanami-cli-0.2.0.beta2`
  * `hanami-mailer-1.2.0.beta2`
  * `hanami-helpers-1.2.0.beta2`
  * `hanami-view-1.2.0.beta2`
  * `hamami-controller-1.2.0.beta2`
  * `hanami-router-1.2.0.beta2`
  * `hanami-validations-1.2.0.beta2`
  * `hanami-utils-1.2.0.beta2`
  * `hanami-webconsole-0.1.0.beta2`
  * `hanami-ujs-0.1.0.beta2`

## How to try it

```shell
gem install hanami --pre
hanami new bookshelf
```

## What's next?

We'll release new beta versions, with enhancements, and bug fixes.
The stable release is expected on **April 2018**, in the meantime, please try this beta and report issues.

Happy coding! 🌸
