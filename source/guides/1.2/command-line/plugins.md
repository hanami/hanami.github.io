---
title: "Guides - Command Line: Plugins"
version: 1.2
---

# Plugins

Hanami has a convenient way to load commands from third party gems, so if you want to add a Hanami compatible gem, you only have to add it inside your project's `Gemfile` in a group called `:plugins`.

Imagine you want to use a fictional gem called `hanami-webpack` and this gem provides several generators, the only thing you need to do, it's add it in the Gemfile in `:plugins` group:

```ruby
group :plugins do
  gem "hanami-webpack"
end
```

After calling hanami webpack command inside your project:

```shell
% bundle exec hanami webpack
```

You can see the new commands that `hanami-webpack` provides:

```shell
hanami webpack install
```

If you call this command, the fictional gem will install webpack in your project.
