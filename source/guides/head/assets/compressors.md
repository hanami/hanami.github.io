---
title: Guides - Assets Compressors
version: head
---

# Assets

## Compressors

Assets compression (aka minification) is a process to shrink the file size of a file in order to reduce the time that a browser needs to download it.
Usually, it's applied to javascripts and stylesheets.

In order to set one of the following engines, we need to open `apps/web/application.rb` and write:

```ruby
# apps/web/application.rb
module Web
  class Application < Hanami::Application
    configure do
      assets do
        javascript_compressor :builtin
        stylesheet_compressor :builtin

        # ...
      end
    end
  end
end
```

If we want to skip compression, just comment one or both the lines above.

### JavaScript

We support the following engines:

  * `:builtin` - It isn't efficient like the other algorithms, but it's a good starting point because it's written in **pure Ruby** and **it doesn't require external dependencies**.
  * `:yui` - It's based on [Yahoo! YUI Compressor](http://yui.github.io/yuicompressor). It requires [`yui-compressor`](https://rubygems.org/gems/yui-compressor) gem and Java 1.4+
  * `:uglifier` - It's based on [UglifyJS2](http://lisperator.net/uglifyjs). It requires [uglifier](https://rubygems.org/gems/uglifier) gem and Node.js
  * `:closure` - It's based on [Google Closure Compiler](https://developers.google.com/closure/compiler). It requires [`closure-compiler`](https://rubygems.org/gems/closure-compiler) gem and Java

<p class="warning">
  In order to use <code>:yui</code>, <code>:uglifier</code> and <code>:closure</code> compressors, you need to add the corresponding gem to <code>Gemfile</code>.
</p>

### Stylesheet

We support the following engines:

  * `:builtin` - It isn't efficient like the other algorithms, but it's a good starting point because it's written in **pure Ruby** and **it doesn't require external dependencies**.
  * `:yui` - It's based on [Yahoo! YUI Compressor](http://yui.github.io/yuicompressor). It requires [`yui-compressor`](https://rubygems.org/gems/yui-compressor) gem and Java 1.4+
  * `:sass` - It's based on [Sass](http://sass-lang.com). It requires [sass](https://rubygems.org/gems/sass) gem

<p class="warning">
  In order to use <code>:yui</code>, and <code>:sass</code> compressors, you need to add the corresponding gem to <code>Gemfile</code>.
</p>

### Custom Compressors

We can use our own compressor for **both JS and CSS**.
It **MUST** respond to `#compress(filename)` and return a `String` with the minification output.

```ruby
class MyCustomJavascriptCompressor
  def compress(filename)
    # ...
  end
end
```

Then we can use it with our configuration:

```ruby
# apps/web/application.rb
module Web
  class Application < Hanami::Application
    configure do
      assets do
        javascript_compressor MyCustomJavascriptCompressor.new
        stylesheet_compressor :builtin

        # ...
      end
    end
  end
end
```
