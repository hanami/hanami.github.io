---
title: Guides - Code Reloading
---

# Code Reloading

_Code reloading_ allows us to edit code and see the changes with a browser refresh, without needing to stop and restart the [server](/guides/command-line/applications).

## Development Environment

This is a development-only feature.
Hanami uses `shotgun` Ruby gem to reload the code as-needed.
New generated projects have this entry in their `Gemfile`:

```ruby
group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/applications/code-reloading
  gem 'shotgun'
end
```

If, for some reason, `shotgun` is not usable in your development environment, you can remove that entry from the `Gemfile` or start the server with the `--no-code-reloading` argument.

## Other Environments

Hanami doesn't implement _code reloading_ in its core.

The framework doesn't know about this feature, it just uses Ruby to load the code and execute it. It's `shotgun` that makes _code reloading_ possible, by wrapping Hanami projects' code.

Because `shotgun` is only enabled in development, all the other environments don't have this _code reloading_ feature.
By excluding this feature from the core of the framework, we make sure that Hanami projects don't mess with Ruby's code loading mechanisms in production.

In other words, once the code is loaded in production, it isn't changed anymore.
