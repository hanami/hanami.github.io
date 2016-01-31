# Middleman-Sprockets

`middleman-sprockets` is an extension for the [Middleman] static site generator that allows support for [Sprockets](https://github.com/sstephenson/sprockets) in your assets.

## Installation

If you're just getting started, install the `middleman` gem and generate a new project:

```
gem install middleman
middleman init MY_PROJECT
```

If you already have a Middleman project: Add `gem "middleman-sprockets"` to your `Gemfile` and run `bundle install`

## Configuration
<a name="configuration"></a>

```
activate :sprockets
```

## Usage

If you want to use, `middleman-sprockets` you need to configure it first - See
[Configuration](#configuration). If you want to use `middleman-sprockets` with
bower, you need to import assets first. The path is relative to your
`bower`-directory.

```
sprockets.import_asset <path>
```

Given `vendor/assets/components` as `bower`-directory and `jquery` as
component-name, you would import the `jquery` production version with:

```
sprockets.append_path 'vendor/assets/components'
sprockets.import_asset 'jquery/dist/jquery'
```

If you tell `sprockets` just about the name of the component, it will make thos
files available which are given in the `main`-section of the `bower.json`-file.

```
sprockets.append_path 'vendor/assets/components'
sprockets.import_asset 'jquery'
```

If you need to tell `sprockets` to use an individual output path for your
asset, you can pass `#import_asset` a block. This block gets the logical path
as
[`Pathname`](http://rdoc.info/stdlib/pathname/frames)
and needs to return the relative output path for the asset as `String` or
`Pathname`.

```
sprockets.append_path 'vendor/assets/components'

# return logical path
sprockets.import_asset 'jquery/dist/jquery' do |logical_path|
  # => prefix/jquery/dist/jquery
  Pathname.new('prefix') + logical_path
end
```

Be careful if you are using `bower`-components which place their assets in
*non-standard*-directories. Fonts should be placed in `fonts`, Stylesheets in
`stylesheets` or `css`, JavaScript-files in `javascripts` or `js` and images in
`images`. If you have got a `svg`-font in a *non*-standard-directory you might
need to use the `#import_asset`-call with the block to place it in the correct
directory.

## Build & Dependency Status

[![Gem Version](https://badge.fury.io/rb/middleman-sprockets.png)][gem]
[![Build Status](https://travis-ci.org/middleman/middleman-sprockets.png)][travis]
[![Dependency Status](https://gemnasium.com/middleman/middleman-sprockets.png?travis)][gemnasium]
[![Code Quality](https://codeclimate.com/github/middleman/middleman-sprockets.png)][codeclimate]

## Community

The official community forum is available at: http://forum.middlemanapp.com

## Bug Reports

Github Issues are used for managing bug reports and feature requests. If you run into issues, please search the issues and submit new problems: https://github.com/middleman/middleman-sprockets/issues

The best way to get quick responses to your issues and swift fixes to your bugs is to submit detailed bug reports, include test cases and respond to developer questions in a timely manner. Even better, if you know Ruby, you can submit [Pull Requests](https://help.github.com/articles/using-pull-requests) containing Cucumber Features which describe how your feature should work or exploit the bug you are submitting.

## How to Run Cucumber Tests

1. Checkout Repository: `git clone https://github.com/middleman/middleman-sprockets.git`
2. Install Bundler: `gem install bundler`
3. Run `bundle install` inside the project root to install the gem dependencies.
4. Run test cases: `bundle exec rake test`

## Donate

[Click here to lend your support to Middleman](https://spacebox.io/s/4dXbHBorC3)

## License

Copyright (c) 2012-2014 Thomas Reynolds. MIT Licensed, see [LICENSE] for details.

[middleman]: http://middlemanapp.com
[gem]: https://rubygems.org/gems/middleman-sprockets
[travis]: http://travis-ci.org/middleman/middleman-sprockets
[gemnasium]: https://gemnasium.com/middleman/middleman-sprockets
[codeclimate]: https://codeclimate.com/github/middleman/middleman-sprockets
[LICENSE]: https://github.com/middleman/middleman-sprockets/blob/master/LICENSE.md
