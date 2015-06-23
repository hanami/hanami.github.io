---
title: Lotus - Guides
---

# Introduction

## What is Lotus?

Lotus is a Ruby MVC web framework comprised of many micro-libraries.
It has a simple, stable API, a minimal DSL, and prioritises the use of plain objects over magical, over-complicated classes with too much responsibility.

The natural repercussion of using simple objects with clear responsibilities is more boilerplate code.
Lotus provides ways to mitigate this extra legwork while maintaining the underlying implementation.

## Why Choose Lotus?

Here are three compelling reasons to choose Lotus:

### Lotus is Lightweight

Lotus's code is relatively short.
It only concerns itself with the things that all web applications&mdash;regardless of implementation&mdash;need.

Lotus ships with several optional modules and other libraries can also be included easily.

### Lotus is Architecturally Sound

If you've ever felt you're stretching against the "Rails way", you'll appreciate Lotus.

Lotus keeps controller actions class-based, making them easier to test in isolation.

Lotus also encourages you to write your application logic in use cases objects (aka _interactors_).

Views are separated from templates so the logic inside can be well-contained and tested in isolation.

### Lotus is Threadsafe

Making use of green threads is a great way to boost the performance of your
application. It shouldn't be hard to write thread-safe code, and Lotus (when
the entire framework, or parts of it) is runtime threadsafe.

## Guides

The guides explain high level Lotus components and how to configure, use and test them in a full stack application.
The imaginary product that we'll mention is called _"Bookshelf"_: a online community to share readings and buy books.

We have a [getting started guide](/guides/getting-started), to build our first application with Lotus.
