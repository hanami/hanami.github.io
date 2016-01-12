---
title: Lotus - Guides - Assets Overview
---

# Assets

Lotus supports powerful features for web assets.

## Configuration

Each application can have its own separated assets settings in application configuration.

### Compile Mode

Toggle this value, to determine if the application must preprocess or copy assets from sources to public directory.
It's turned on by default in _development_ and _test_ environments, but turned off for _production_.

```ruby
# apps/web/application.rb
module Web
  class Application < Lotus::Application
    configure do
      # ...
      assets do
        # compile true, enabled by default
      end
    end

    configure :production do
      assets do
        compile false
      end
    end
  end
end
```

### Digest Mode

In order to force browsers to cache the right copy of an asset, during the deploy, Lotus creates a copy of each file by [appending its checksum](/guides/command-line/assets) to the file name.

We can control this feature via application configuration.
It's turned on by default only in _production_ environment.

```ruby
# apps/web/application.rb
module Web
  class Application < Lotus::Application
    configure do
      # ...
      assets do
        # digest false, disabled by default
      end
    end

    configure :production do
      assets do
        digest true
      end
    end
  end
end
```

If enabled, [assets helpers](/guides/helpers/assets) will generate checksum relative URLs.

```erb
<%= javascript 'application' %>
```

```html
<script src="/assets/application-d1829dc353b734e3adc24855693b70f9.js" type="text/javascript"></script>
```

## Serve Static Assets

It can dinamically serve them during development.
It mounts `Lotus::Static` middleware in project Rack stack. This component is conditionally activated, if the environment variable `SERVE_STATIC_ASSETS` equals to `true`.

By default, new projects are generated with this feature enabled in _development_ and _test_ mode, via their corresponding `.env.*` files.

```
# .env.development
# ...
SERVE_STATIC_ASSETS="true"
```

Lotus assumes that projects in _production_ mode are deployed using a web server like Nginx that is responsible to serve them without even hitting the Ruby code.

<p class="convention">
  Static assets serving is enabled by default in <em>development</em> and <em>test</em> environments, but turned off for <em>production</em>.
</p>

There are cases where this assumption isn't true. For instance, Heroku requires Ruby web apps to serve static assets.
To enable this feature in production, just make sure that this special environment variable is set to `true` (in `.env` or `.env.production`).

### What Does It Mean To Serve Static Assets With Lotus?

As mentioned above, when this feature is enabled, a special middleware is added in front of the project Rack stack: `Lotus::Static`.

Incoming requests can generate the following use cases

#### Fresh Asset

```
GET /assets/application.js
```

It copies the `apps/web/assets/javascripts/application.js` to `public/assets/application.js` and then serves it.

<p class="notice">
  Assets are copied only if the destination path is NOT existing (eg. <code>public/assets/application.js</code>).
  If it DOES exist, the asset is only served, without copying it.
</p>

<p class="warning">
  When an application has turned OFF assets compilation (Compile mode), Lotus won't copy the file.
</p>

#### Stale Asset

This could happen in _development_ mode, when we require an asset the first time, it's get copied over `public/`, then we edit it, so the destination file is stale.

```
GET /assets/application.js
# edit the original file: apps/web/assets/javascripts/application.js
# then require it again
GET /assets/application.js
```

It copies **again** the source into the destination file (`public/assets/application.js`) and then serves it.

#### Precompiled Asset

Let's say we use Sass to write our stylesheets.

```
GET /assets/application.css
```

It preprocess the `apps/web/assets/stylesheet/application.css.sass` to `public/assets/application.css` and then serves it.

#### Dynamic Resource

```
GET /books/23
```

This isn't a static file available under `public/`, so the control passes to the backend that hits the appropriate action.

#### Missing Resource

```
GET /unknown
```

This isn't a static file or a dynamic resource, the project returns a `404 (Not Found)`.

## Sources

Each application has a separated set of directories where to look up for files.
Assets are recursively searched under these paths.

New projects have a default directory where to put application assets:

```
% tree apps/web/assets
apps/web/assets
├── favicon.ico
├── images
├── javascripts
└── stylesheets

3 directories, 1 file
```

We can add as many directories we want under it (eg. `apps/web/assets/fonts`).

<p class="convention">
  For a given application named <code>Web</code>, the default assets source is <code>apps/web/assets</code>
</p>

### Adding Sources

If we want add other sources for a given application, we can specify them in the configuration.

```ruby
# apps/web/application.rb
module Web
  class Application < Lotus::Application
    configure do
      # ...
      assets do
        # apps/web/assets is added by default
        sources << [
          'vendor/assets'
        ]
      end
    end
  end
end
```

This will add `apps/web/vendor/assets` and all its subdirectories.

<p class="warning">
  Lotus looks recursively to the assets sources. In order to NOT accidentally disclose sensitive files like secrets or source code, please make sure that these sources directories ONLY contain web assets.
</p>

## Third Party Gems

Lotus allows to use [Rubygems](https://rubygems.org) as a way to distribute web assets and make them available to Lotus applications.

Third party gems can be maintained by developers who want to bring frontend frameworks support to Lotus.
Let's say we want to build an `lotus-emberjs` gem.

```shell
% tree .
# ...
├── lib
│   └── lotus
│       ├── emberjs
│       │   ├── dist
│       │   │   ├── ember.js
│       │   │   └── ember.min.js
│       │   └── version.rb
│       └── emberjs.rb
├── lotus-emberjs.gemspec
# ...
```

We put in an **arbitrary** directory **only** the assets that we want to serve.
Then we add it to `Lotus::Assets.sources`.

```ruby
# lib/lotus/emberjs.rb
require 'lotus/assets'

module Lotus
  module Emberjs
    require 'lotus/emberjs/version'
  end
end

Lotus::Assets.sources << __dir__ + '/emberjs/source'
```

When an application will do `require 'lotus/emberjs'`, that directory will be added to the sources where Lotus will be able to lookup for assets.

```erb
<%= javascript 'ember' %>
```

We can use the `javascript` [helper](/guides/helpers/assets) to include `ember.js` in our application.
