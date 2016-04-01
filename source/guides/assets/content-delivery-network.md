---
title: Guides - Assets Content Delivery Network (CDN)
---

# Assets

## Content Delivery Network (CDN)

A Hanami application can serve assets from a [Content Delivery Network](https://en.wikipedia.org/wiki/Content_delivery_network) (CDN).
This feature is useful in _production_ environment, where we want to speed up static assets serving.

In order to take advantage of this feature, we need to specify CDN settings.

```ruby
# apps/web/application.rb
module Web
  class Application < Hanami::Application
    # ...
    configure :production do
      scheme 'https'
      host   'bookshelf.org'
      port   443

      assets do
        # ...
        digest true

        # CDN settings
        scheme 'https'
        host   '123.cloudfront.net'
        port   443
      end
    end
  end
end
```

Once _CDN mode_ is on, all the [asset helpers](/guides/helpers/assets) will return **absolute URLs**.

```erb
<%= stylesheet 'application' %>
```

```html
<link href="https://123.cloudfront.net/assets/application-9ab4d1f57027f0d40738ab8ab70aba86.css" type="text/css" rel="stylesheet">
```
