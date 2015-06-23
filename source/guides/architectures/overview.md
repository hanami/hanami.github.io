---
title: Lotus - Guides - Architectures
---

# Architectures

Lotus is a **modular** web framework.
It scales from **single file HTTP endpoints** to **multiple Lotus (or Rack based) applications in the same Ruby process**.

Each application is a component to our product.
It can be the user web facing UI, an admin pane, a HTTP API, metrics etc..

Splitting these parts from the beginning, helps us to follow the [monolith first](http://martinfowler.com/bliki/MonolithFirst.html) principles.
We want to achieve fast iterations for our MVP, and have a tight feedback loop.
The most natural approach is to build all our components **together** in the same code base.

Once our application grows in complexity we decide to extract each component into a standalone [microservice](http://martinfowler.com/articles/microservices.html).

## Container

To make this possible, Lotus' default architecture is called [**Container**](/guides/architectures/container).
It hosts several applications in the same Ruby process.

Each component (application) has its own Ruby namespace (eg `Web` or `Admin`) that is a strong boundary between them.
When (and **if**) we want to extract one of them, we can easily do it.

In other words, Lotus is providing gentle guidance to help build component based applications.
We **strongly** suggest starting your next project with this architecture.

## Application

[**Application**](/guides/architectures/application) architecture can be used for small components.

Imagine we have build a big and successful product (with Container) that now needs a small application to report daily/weekly/monthly revenues.
Instead of adding yet another component to our main product, we can use a **single purposed** application (microservice) for our needs.

We suggest using this architecture only at the later stage of your products lifecycle.

