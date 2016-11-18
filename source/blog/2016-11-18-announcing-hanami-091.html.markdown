---
title: Announcing Hanami v0.9.1
date: 2016-11-18 15:11 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Security patch for JSON body parsers
---

This is a security patch for [JSON body parsers](/guides/actions/parameters#body-parsers).

## The Problem

JSON body parsing was implemented using `Hanami::Utils::Json.load`, which internally uses `JSON.load`.
According to Ruby docs, `JSON.load` should be used only with trusted data, because it evals the given payload.

Thanks to [Lucas Hosseini](https://github.com/beauby) for spotting this problem.

## The Fix

We introduced `Hanami::Utils::Json.parse`, which is a safe alternative for JSON parsing.
JSON body parser now uses this new method, in order to guaratee a higher level of safety.

## How To Fix Your Project

From the root of your Hanami project: `bundle update hanami`.

## Released Gems

  * `hanami-0.9.1`
  * `hanami-utils-0.9.1`
  * `hanami-router-0.8.1`
  * `hanami-validations-0.7.1`
