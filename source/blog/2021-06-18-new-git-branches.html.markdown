---
title: New Git Branches
date: 2021-06-18 06:57:41 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  New Git branches system, renamed master in favor of main. Main contains code for Hanami 2.0.
---

Hello, Hanami community!
We put in place a simplified Git branches system.

**TL;DR: Renamed `master` into `main`. `main` contains the code for Hanami 2.0.**

Let's have a look at the details. For all the Hanami GitHub repositories:

  * `master` , `develop`, `unstable` branches are gone
  * `master` branches were merged into _stable branches_ (see below)
    * Example: `hanami/hanami` `master` branch was hosting Hanami 1.3 code. Now that code is part of the `1.3.x` branch.
  * `main` is the new default branch for all the repositories
  * `main` hosts the new work, new features (aka Hanami 2)
    * **Use these branches to merge new features**
  * _Stable branches_ host the maintenance work (aka Hanami 1).
  *   They are named after SemVer `Major.Minor.x` (e.g. `1.3.x`).
    * **Use these branches for maintenance**

ℹ️ CI status for `main` and _stable branches_ can be observed in the 🚦 [status](/status) page of our website.
