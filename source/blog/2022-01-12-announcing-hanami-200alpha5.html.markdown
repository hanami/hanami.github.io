---
title: Announcing Hanami v2.0.0.alpha5
date: 2022-01-12 11:00:00 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  Sensible default logger, full source dirs config, router loading flexibility, route helpers in views
---

Happy new year, Hanami community! To get 2022 started, we're excited to announce the release of Hanami 2.0.0.alpha5!

This release brings the last month of our work on Hanami 2.0 (with an extra week added for good measure, while we all returned from our end of year breaks). It includes:

- Sensible default configuration for the application logger
- Comprehensive `source_dirs` configuration
- Lazy router and Rack app initialization
- Access to the application route helpers from the view context
- RSS support in our default MIME type list

## Default application logger configuration

In our ongoing effort to strip boilerplate from our [application template](https://github.com/hanami/hanami-2-application-template), we now ship a sensible default configuration for the application logger.

The defaults are:

- In **production**, log for level `info`, send logs to `$stdout` in JSON format without colours
- In **development**, log for level `debug`, send logs to `$stdout` in single-line format with colours
- In **test**, log for level `debug`, send logs to `log/test.log` in single-line format without colours

These defaults mean we've now achieved sensible behavior for a zero-configuration Hanami application class:

```ruby
# config/application.rb

require "hanami"

module MyApp
  class Application < Hanami::Application
  end
end
```

You can customise the logger config as much as you need:

```ruby
module MyApp
  class Application < Hanami::Application
    config.logger.level = :info

    config.logger.stream = $stdout
    config.logger.stream = "/path/to/file"
    config.logger.stream = StringIO.new

    config.logger.format = :json
    config.logger.format = MyCustomFormatter.new

    config.logger.color = false # disable coloring
    config.logger.color = MyCustomColorizer.new

    config.logger.filters << "secret" # add
    config.logger.filters += ["yet", "another"] # add
    config.logger.filters = ["foo"] # replace

    # See https://ruby-doc.org/stdlib/libdoc/logger/rdoc/Logger.html
    config.logger.options = ["daily"] # time based log rotation
    config.logger.options = [0, 1048576] # size based log rotation
  end
end
```

You can also customise the config specifically for given environments:

```ruby
module MyApp
  class Application < Hanami::Application
    config.environment(:staging) do
      config.logger.level = :info
    end
  end
end
```

And finally, you can assign a completely custom logger object:

```ruby
module MyApp
  class Application < Hanami::Application
    config.logger = MyCustomLogger.new
  end
end
```

## Comprehensive `source_dirs` configuration

In the 2.0.0.alpha3 release, we introduced [streamlined source directories](/blog/2021/11/09/announcing-hanami-200alpha3/) for the Ruby source files within each slice. Just like we’re doing with our application logger, we ship a sensible default configuration out of the box. Now with alpha5, we’re introducing a new `config.source_dirs` setting that you can use to fully customise this configuration.

This will allow you to add and configure your own additional component dirs (which are the directories used to auto-register application components):

```ruby
module MyApp
  class Application < Hanami::Application
    # Adding a simple component dir
    config.source_dirs.component_dirs.add "serializers"

    # Adding a component dir with custom configuration
    config.source_dirs.component_dirs.add "serializers" do |dir|
      dir.auto_register = proc { |component|
        !component.identifier.start_with?("structs")
      }
    end
  end
end
```

You can also customise the configuration of the default component dirs ("lib", "actions", "repositories", "views"):

```ruby
module MyApp
  class Application < Hanami::Application
    # Customising a default component dir
    config.source_dirs.component_dirs.dir("lib").auto_register = proc { |component|
      !component.identifier.start_with?("structs")
    }

    # Setting default config to apply to all component dirs
    config.source_dirs.component_dirs.auto_register = proc { |component|
      !component.identifier.start_with?("entities")
    }

    # Removing a default component dir
    config.source_dirs.component_dirs.delete("views")
  end
end
```

The `component_dirs` setting is provided by [dry-system’s](http://dry-rb.org/gems/dry-system/0.21/) own `Dry::System::Config::ComponentDirs`, so you can use this to configure every possible aspect of component loading as you require.

In addition to component dirs, you can also configure your own autoload paths, for source files you don’t want registered as components, but whose classes you still want to access inside your application. These directories are helpful for any classes that you will directly instantiate with their own data rather than dependencies, such as entities, structs, or any other kind of value class.

Out of the box, our `autoload_paths` is `["entities"]`. You can configure this as required:

```ruby
module MyApp
  class Application < Hanami::Application
    # Adding your own autoload paths
    config.source_dirs.autoload_paths << "structs"

    # Or providing a full replacement
    config.source_dirs.autoload_paths = ["structs"]
  end
end
```

## Lazy router and Rack app initialization

One of the most powerful features of Hanami 2 is your ability to partially boot the application, loading only the specific components you need to complete a particular task. This makes unit testing testing considerably faster, but it also opens up flexible deployment opportunities, such as optimising the performance of certain production workloads by only loading particular subsets of your application.

With this release, this flexibility has been extended to the application router and its Rack interface, which are now initialized lazily, allowing you to access the router and rack app even if your application has not fully booted. The rack app is now available as `.rack_app` on your application class, and can be accessed at any time after the initial "init" step:

```ruby
# Example config.ru

# Loads the Hanami app at config/application.rb and runs Hanami.init
#
# n.b. this does _not_ fully boot the application, so most components are not loaded
require "hanami/init"

run Hanami.rack_app
```

Access to the Rack app in this way opens up the possibility of a slimeline deployment of a your application configured to serve only a small subset of its overall routes. In this case, only the minimal subset of components will be loaded to serve the given routes. This may be helpful for fine-grained deployment to resource-constrained targets like serverless functions.

## Route helpers via the view context

Last month we made the [route helpers available in actions](/blog/2021/12/07/announcing-hanami-200alpha4/), and now we’re making them available in views too, via our default [view context](https://dry-rb.org/gems/dry-view/0.7/context/). This means  you can access `routes` inside any template:

```slim
/ slices/main/web/templates/books/index.html.slim

- books.each do |book|
  p
    a href=routes.url(:book, id: book.id) = book.title
```

Given the context is exposed to view [parts](https://dry-rb.org/gems/dry-view/0.7/parts/) and [scopes](https://dry-rb.org/gems/dry-view/0.7/scopes/), you can access `routes` there as well.

## RSS support in our default MIME type list

You can now configure your Hanami actions to work with RSS formatted requests and responses via the new `rss` entry in our default MIME types list.

## What’s included?

Today we’re releasing the following gems:

- hanami v2.0.0.alpha5
- hanami-controller v2.0.0.alpha5
- hanami-view v2.0.0.alpha5

## How can I try it?

You can check out our [Hanami 2 application template](https://github.com/hanami/hanami-2-application-template), which is up to date for this latest release and ready for you to use out as the starting point for your own app.

## What’s coming next?

We’ll be back in February for alpha6, bringing our next month of development direct to you.
