---
title: Guides - Applications Initializers
---

# Initializers

Each single Hanami application within a project can **optionally** have one or more custom initializers.

<p class="notice">
  Initializers are optional
</p>

They are run **after** the dependencies, the framework and the application code are loaded, but **before** the server or the console are started.

<p class="convention">
  For a given application named <code>Web</code>, they MUST be placed under <code>apps/web/config/initializers</code>.
</p>

<p class="warning">
  Initializers are executed in alphabetical order.
</p>
