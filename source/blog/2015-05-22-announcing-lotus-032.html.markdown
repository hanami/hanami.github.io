---
title: Announcing Lotus v0.3.2
date: 2015-05-22 07:14 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Lotus patch release: Automatic secure cookies, action file send and routing helpers, optional contents for views, Rake "environment" task, Lotus.root and bug fixes.
---

## Features

This patch release ships new minor features.

### Automatic Secure Cookies

According to the cookies RFC, we can specify a `Secure` option, to make a coookie available only under HTTPS.
If we are using a crypted connection in production, Lotus will automatically send this option to increase security level.
In development mode, where SSL is turned off, that value is omitted.

We can manually handle this setting, according to our custom needs.

```ruby
# apps/web/application.rb
module Web
  class Application
    configure do
      # ...
      cookies secure: true
    end
  end
end
```

### Action Routing Helpers

There is a new API available for routes interaction.
It's available as private method in actions and provides useful facilities to generate URLs for named routes.


```ruby
# apps/web/controllers/home/index.rb
module Web::Controllers::Home
  class Index
    include Web::Action

    def call(params)
      puts routes.root_path
      puts routes.root_url

      # equivalent to

      puts routes.path(:root)
      puts routes.url(:root)
    end
  end
end
```

The same feature for views was already introduced by v0.3.0.

### Action Send File

Another useful addition for actions is `#send_file`.
It accepts a Ruby `File` objects and deliver to the client.
It supports automatic MIME type handling, Conditional GET, HEAD requests and chunked responses (via `Range` header).


```ruby
# apps/web/controllers/home/index.rb
module Web::Controllers::Documents
  class Download
    include Web::Action

    def call(params)
      send_file File.new('path/to/document.txt')
    end
  end
end
```

### Optional Content For Views

If we want to render optional contents such as sidebar links or page specific javascripts, we can use `#content`
It accepts a key that represents a method that should be available within the rendering context.
That context is made of the locals, and the methods that view and layout respond to.
If the context can't dispatch that method, it returns `nil`.

Given the following layout template.

```erb
<!doctype HTML>
<html>
  <!-- ... -->
  <body>
    <!-- ... -->
    <%= content :footer %>
  </body>
</html>
```

We have two views, one responds to `#footer` (`Web::Views::Products::Show`) and the other doesn't (`Web::Views::Products::Index`).
When the first is rendered, `content` gives back the returning value of `#footer`.
In the other case, `content` returns `nil`.

```ruby
module Products
  class Index
    include Lotus::View
  end

  class Show
    include Lotus::View

    def footer
      "contents for footer"
    end
  end
end
```

### Environment Rake Task

If we need to run a Rake task and need the entire environment loaded, we can use `:environment` as a dependency.

```ruby
# Rakefile
namespace :storage do
  desc 'Clear local storage'
  task clear: :environment do
    # ...
  end
end
```

### Lotus.root

We have introduced `Lotus.root` as facility to easily get the top level directory of the project.

## Bug Fixes

This release comes with some bug fixes for code generators file naming, RSpec support and dirty tracking.

<div style="display: inline">
  <iframe src="https://ghbtns.com/github-btn.html?user=lotus&repo=lotus&type=star&count=true&size=large" frameborder="0" scrolling="0" width="160px" height="30px"></iframe>

  <a href="https://news.ycombinator.com/submit" class="hn-button" data-title="Announcing Lotus v0.3.2" data-url="http://lotusrb.org/blog/2015/05/22/announcing-lotus-032.html" data-count="horizontal" data-style="facebook">Vote on Hacker News</a>
  <script type="text/javascript">var HN=[];HN.factory=function(e){return function(){HN.push([e].concat(Array.prototype.slice.call(arguments,0)))};},HN.on=HN.factory("on"),HN.once=HN.factory("once"),HN.off=HN.factory("off"),HN.emit=HN.factory("emit"),HN.load=function(){var e="hn-button.js";if(document.getElementById(e))return;var t=document.createElement("script");t.id=e,t.src="//hn-button.herokuapp.com/hn-button.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(t,n)},HN.load();</script>
  <script type="text/javascript">
    reddit_url = "http://lotusrb.org/blog/2015/05/22/announcing-lotus-032.html";
  </script>
  <script type="text/javascript" src="//www.redditstatic.com/button/button1.js"></script>
</div>
