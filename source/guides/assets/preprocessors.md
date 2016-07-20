---
title: Guides - Assets Preprocessors
---

# Assets

## Preprocessors

Hanami is able to run assets preprocessors and **lazily compile** them under `public/assets`.

Imagine to have `application.css.scss` in `apps/web/assets/stylesheets` and `reset.css` under
`apps/web/vendor/stylesheets`.

**The extensions structure is important.**
The first one is mandatory and it's used to understand which asset type we are
handling: `.css` for stylesheets.
The second one is optional and it's for a preprocessor: `.scss` for Sass.

<p class="convention">
  For a given asset <code>application.css.scss</code>, the last extension (<code>.scss</code>) is used to determine the right preprocessor.
</p>

<p class="notice">
  Preprocessors are optional, an application can work with plain javascripts or stylesheets. In this case we have to name our assets with only one extension (eg <code>application.css</code>).
</p>

```ruby
# apps/web/application.rb
require 'sass'

module Web
  class Application < Hanami::Application
    configure do
      # ...

      assets do
        sources << [
          # apps/web/assets is added by default
          'vendor/assets' # app/web/vendor/assets
        ]
      end
    end
  end
end
```

From a template we do:

```erb
<%= stylesheet 'reset', 'application' %>
```

When we'll load the page the compiler will preprocess or copy the assets into `public/assets`.

```shell
% tree public
public/
└── assets
    ├── application.css
    └── reset.css
```

Preprocessors will compile/copy assets only if the [_Compile mode_](/guides/assets/overview) is on.

<p class="convention">
  Preprocessors are enabled by default in <em>development</em> and <em>test</em> environments.
</p>

For performance reasons, this feature is turned off in _production_ env, where we should [precompile](/guides/command-line/assets) our assets.

### Preprocessors Engines

Hanami uses [Tilt](https://github.com/rtomayko/tilt) to provide support for the most common preprocessors, such as [Sass](http://sass-lang.com/) (including `sassc-ruby`), [Less](http://lesscss.org/), ES6, [JSX](https://jsx.github.io/), [CoffeScript](http://coffeescript.org), [Opal](http://opalrb.org), [Handlebars](http://handlebarsjs.com), [JBuilder](https://github.com/rails/jbuilder).

In order to use one or more of them, be sure to include the corresponding gem into your `Gemfile` and require the library.

```ruby
# Gemfile
# ...
gem 'sass'
```

<p class="notice">
  Some preprocessors may require Node.js. Please check the documentation.
</p>

#### EcmaScript 6

We strongly suggest to use [EcmaScript 6](http://es6-features.org/) for your next project, because that is the next version of JavaScript.
It isn't fully [supported](https://kangax.github.io/compat-table/es6/) yet by browser vendors, but this is changing quickly.

As of today, you need to transpile ES6 code into something understandable by current browsers, which is ES5.
For this purpose we support [Babel](https://babeljs.io).

<p class="notice">
  Babel requires Node.js.
</p>
