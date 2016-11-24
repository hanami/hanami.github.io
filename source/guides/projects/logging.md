---
title: Guides - Logging
---

# Logging

Within a project, each application has its own logger

<p class="convention">
  For a given application named <code>Web</code>, logger is accessible at <code>Web.logger</code>.
</p>

Using the per-environment application settings we can define the behavior of the logger: the destination `stream`, `format`, and `level`.
For instance, the default destination stream is standard output, but we can use a file instead.

```ruby
# apps/web/application.rb
module Web
  class Application < Hanami::Application
    # ...

    configure :development do
      # ...

      # Logger
      # See: http://hanamirb.org/guides/projects/logging
      #
      # Logger stream. It defaults to STDOUT.
      # logger.stream "log/development.log"
      #
      # Logger level. It defaults to DEBUG
      # logger.level :debug
      #
      # Logger format. It defaults to DEFAULT
      # logger.format :default
    end

    ##
    # TEST
    #
    configure :test do
      # ...

      # Logger
      # See: http://hanamirb.org/guides/projects/logging
      #
      # Logger level. It defaults to ERROR
      logger.level :error
    end

    ##
    # PRODUCTION
    #
    configure :production do
      # ...

      # Logger
      # See: http://hanamirb.org/guides/projects/logging
      #
      # Logger stream. It defaults to STDOUT.
      # logger.stream "log/production.log"
      #
      # Logger level. It defaults to INFO
      logger.level :info

      # Logger format.
      logger.format :json
    end
  end
end
```

Using standard output is a [best practice](http://12factor.net/logs) that most hosting SaaS companies [suggest using](https://devcenter.heroku.com/articles/rails4#logging-and-assets).

Because of its parseability, JSON is the default format for production environment, where you may want aggregate information about the project usage.

The logger is very similar to Ruby's `Logger`; you can use it like this:

```ruby
Web.logger.debug "Hello"
```
