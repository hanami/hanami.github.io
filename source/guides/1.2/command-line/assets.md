---
title: "Guides - Command Line: Assets"
version: 1.2
---

# Assets

We can manage assets via the command line.

## Precompile

This command is useful for **deployment** purposes.

```shell
% bundle exec hanami assets precompile
```

The first step it precompiles and copies all the assets from all the applications and third party gems under `public/assets/` directory.

Then it [compress](/guides/1.2/assets/compressors) all the javascripts and stylesheets, in order to save browsers bandwidth.

As last thing, it generates a copy of each asset, by appending its checksum to the file name.
This trick makes assets cacheable by browsers.

It generates a fingeprint manifest that lists all the assets and their checksum counterpart.

```shell
% cat public/assets.json
{
  # ...
  "/assets/application.css":"/assets/application-9ab4d1f57027f0d40738ab8ab70aba86.css"
}
```

This is used by assets helpers to resolve an asset name into a relative path.

## Example

Let's say we have a project with three applications: `admin`, `metrics` and `web`.

```ruby
# config/environment.rb
# ...
Hanami::Container.configure do
  mount Metrics::Application, at: '/metrics'
  mount Admin::Application,   at: '/admin'
  mount Web::Application,     at: '/'
end
```

They have the following sources:

  * Admin: `apps/admin/assets`
  * Metrics: `apps/metrics/assets`
  * Web: `apps/web/assets`, `apps/web/vendor/assets`

Furtermore, they all depend on Ember.js, which is distributed by an imaginary gem named `hanami-ember`.

```shell
% tree .
├── apps
│   ├── admin
│   │   ├── assets
│   │   │   └── js
│   │   │       ├── application.js
│   │   │       └── zepto.js
# ...
│   ├── metrics
│   │   ├── assets
│   │   │   └── javascripts
│   │   │       └── dashboard.js.es6
# ...
│   └── web
│       ├── assets
│       │   ├── images
│       │   │   └── bookshelf.jpg
│       │   └── javascripts
│       │       └── application.js
# ...
│       └── vendor
│           └── assets
│               └── javascripts
│                   └── jquery.js
# ...
```

When we run `hanami assets precompile` on our server, here's the output.

```shell
% tree public
public
├── assets
│   ├── admin
│   │   ├── application-28a6b886de2372ee3922fcaf3f78f2d8.js
│   │   ├── application.js
│   │   ├── ember-b2d6de1e99c79a0e52cf5c205aa2e07a.js
│   │   ├── ember-source-e74117fc6ba74418b2601ffff9eb1568.js
│   │   ├── ember-source.js
│   │   ├── ember.js
│   │   ├── zepto-ca736a378613d484138dec4e69be99b6.js
│   │   └── zepto.js
│   ├── application-d1829dc353b734e3adc24855693b70f9.js
│   ├── application.js
│   ├── bookshelf-237ecbedf745af5a477e380f0232039a.jpg
│   ├── bookshelf.jpg
│   ├── ember-b2d6de1e99c79a0e52cf5c205aa2e07a.js
│   ├── ember-source-e74117fc6ba74418b2601ffff9eb1568.js
│   ├── ember-source.js
│   ├── ember.js
│   ├── jquery-05277a4edea56b7f82a4c1442159e183.js
│   ├── jquery.js
│   └── metrics
│       ├── dashboard-7766a63ececc63a7a629bfb0666e9c62.js
│       ├── dashboard.js
│       ├── ember-b2d6de1e99c79a0e52cf5c205aa2e07a.js
│       ├── ember-source-e74117fc6ba74418b2601ffff9eb1568.js
│       ├── ember-source.js
│       └── ember.js
└── assets.json
```

<p class="convention">
  The structure of the output directories in <code>public/assets</code>, reflects the path prefix of each application. The default application named <code>Web</code>, is mounted at <code>/</code>, so the output directory is <code>public/assets</code> and their base URL is <code>/assets</code> (eg. <code>/assets/application-28a6b886de2372ee3922fcaf3f78f2d8.js</code>).
  Simirarly, for an application <code>Admin</code> mounted at <code>/admin</code>, the assets will be placed under <code>public/assets/admin</code> and reachable at <code>/assets/admin/application-28a6b886de2372ee3922fcaf3f78f2d8.js</code>.
</p>
