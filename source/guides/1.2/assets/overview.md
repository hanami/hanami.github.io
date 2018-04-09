---
title: Guides - Assets Overview
version: 1.2
---

# Assets

Hanami supports powerful features for web assets.

## Configuration

Each application can have its own separated assets settings in application configuration.

### Compile Mode

Toggle this value, to determine if the application must preprocess or copy assets from sources to public directory.
It's turned on by default in _development_ and _test_ environments, but turned off for _production_.

```ruby
# apps/web/application.rb
module Web
  class Application < Hanami::Application
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

### Fingerprint Mode

In order to force browsers to cache the right copy of an asset, during the deploy, Hanami creates a copy of each file by [appending its checksum](/guides/1.2/command-line/assets) to the file name.

We can control this feature via application configuration.
It's turned on by default only in _production_ environment.

```ruby
# apps/web/application.rb
module Web
  class Application < Hanami::Application
    configure do
      # ...
      assets do
        # fingerprint false, disabled by default
      end
    end

    configure :production do
      assets do
        fingerprint true
      end
    end
  end
end
```

If enabled, [assets helpers](/guides/1.2/helpers/assets) will generate checksum relative URLs.

```erb
<%= javascript 'application' %>
```

```html
<script src="/assets/application-d1829dc353b734e3adc24855693b70f9.js" type="text/javascript"></script>
```

## Serve Static Assets

It can dynamically serve them during development.
It mounts `Hanami::Static` middleware in project Rack stack. This component is conditionally activated, if the environment variable `SERVE_STATIC_ASSETS` equals to `true`.

By default, new projects are generated with this feature enabled in _development_ and _test_ mode, via their corresponding `.env.*` files.

```
# .env.development
# ...
SERVE_STATIC_ASSETS="true"
```

Hanami assumes that projects in _production_ mode are deployed using a web server like Nginx that is responsible to serve them without even hitting the Ruby code.

<p class="convention">
  Static assets serving is enabled by default in <em>development</em> and <em>test</em> environments, but turned off for <em>production</em>.
</p>

There are cases where this assumption isn't true. For instance, Heroku requires Ruby web apps to serve static assets.
To enable this feature in production, just make sure that this special environment variable is set to `true` (in `.env` or `.env.production`).

### What Does It Mean To Serve Static Assets With Hanami?

As mentioned above, when this feature is enabled, a special middleware is added in front of the project Rack stack: `Hanami::Static`.

Incoming requests can generate the following use cases

#### Fresh Asset

```
GET /assets/application.js
```

It copies the `apps/web/assets/javascripts/application.js` to `public/assets/application.js` and then serves it.

<p class="notice">
  Assets are copied only if the destination path does <em>NOT</em> exist (eg. <code>public/assets/application.js</code>).
  If it <em>DOES</em> exist, the asset is only served, without copying it.
</p>

<p class="warning">
  When an application has turned <em>OFF</em> asset compilation (Compile mode), Hanami won't copy the file.
</p>

#### Stale Asset

This could happen in _development_ mode. When we require an asset the first time it gets copied to the `public/` directory. Then when we edit the source file, the destination file becomes stale.

```
GET /assets/application.js
# edit the original file: apps/web/assets/javascripts/application.js
# then require it again
GET /assets/application.js
```

It copies the source into the destination file **again** (`public/assets/application.js`) and then serves it.

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

Each application has a separated set of directories where its assets can be found.
Assets are recursively searched under these paths.

New projects have a default directory where application assets can be put:

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
  For a given application named <code>Web</code>, the default asset directory is <code>apps/web/assets</code>
</p>

### Adding Sources

If we want add other sources for a given application, we can specify them in the configuration.

```ruby
# apps/web/application.rb
module Web
  class Application < Hanami::Application
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
  Hanami looks recursively through the asset sources. In order to <em>NOT</em> accidentally disclose sensitive files like secrets or source code, please make sure that these sources directories <em>ONLY</em> contain web assets.
</p>

## Third Party Gems

Hanami allows developers to use [Rubygems](https://rubygems.org) as a way to distribute web assets and make them available to Hanami applications.

Third party gems can be maintained by developers who want to bring frontend framework support to Hanami.
Let's say we want to build an `hanami-emberjs` gem.

```shell
% tree .
# ...
├── lib
│   └── hanami
│       ├── emberjs
│       │   ├── dist
│       │   │   ├── ember.js
│       │   │   └── ember.min.js
│       │   └── version.rb
│       └── emberjs.rb
├── hanami-emberjs.gemspec
# ...
```

We put **only** the assets that we want to serve in an **arbitrary** directory.
Then we add it to `Hanami::Assets.sources`.

```ruby
# lib/hanami/emberjs.rb
require 'hanami/assets'

module Hanami
  module Emberjs
    require 'hanami/emberjs/version'
  end
end

Hanami::Assets.sources << __dir__ + '/emberjs/source'
```

When an application requires `'hanami/emberjs'`, that directory will be added to the sources where Hanami can search for assets.

```erb
<%= javascript 'ember' %>
```

We can use the `javascript` [helper](/guides/1.2/helpers/assets) to include `ember.js` in our application.
