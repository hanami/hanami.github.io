---
title: Guides - Project Initializers
---

# Initializers

A project can **optionally** have one or more custom initializers.

<p class="notice">
  Initializers are optional
</p>

An initializer is a Ruby file used to setup third-party libraries or some other aspect of the code.

They are run as the **last** thing after the dependencies, the framework and the project code are loaded, but **before** the server or the console are started.

For instance, if we want to setup [Bugsnag](https://bugsnag.com) for our project we can do:

```ruby
# config/initializers/bugsnag.rb
require 'bugsnag'

Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_API_KEY']
end
```

<p class="convention">
  Project initializers must be added under <code>config/initializers</code>.
</p>

<p class="warning">
  Initializers are executed in alphabetical order.
</p>
