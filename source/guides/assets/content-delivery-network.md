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
        fingerprint true

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

## Subresource Integrity

A CDN can dramatically improve page speed, but it can potentially open a security breach.
If the CDN that we're using is compromised and serves evil javascript or stylesheet files, we're exposing our users to security attacks like Cross Site Scripting (XSS).

To solve this problem, browsers vendors introduced a defense called [Subresource Integrity](https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity).

When enabled, the browser verifies that the checksum of the downloaded file, matches with the declared one.

### From A CDN

If we're using jQuery from their CDN, we should find the checksum of the `.js` file on their website and write:

```erb
<%= javascript 'https://code.jquery.com/jquery-3.1.0.min.js', integrity: 'sha256-cCueBR6CsyA4/9szpPfrX3s49M9vUU5BgtiJj06wt/s=' %>
```

The output will be:

```html
<script integrity="sha256-cCueBR6CsyA4/9szpPfrX3s49M9vUU5BgtiJj06wt/s=" src="https://code.jquery.com/jquery-3.1.0.min.js" type="text/javascript" crossorigin="anonymous"></script>
```

### Local Assets

The security problem described above doesn't concern only CDNs, but local files too.
Imagine we have a compromised file system and someone was able to replace our javascripts with evil files: we would be vulnerable to the same kind of attack.

As a defense against this security problem, Hanami **enables Subresource Integrity by default in production.**
When we [precompile assets](/guides/command-line/assets) at deploy time, Hanami calculates the checksum of all our assets and it adds a special HTML attribute `integrity` to our asset tags like `<script>`.

```erb
<%= javascript 'application' %>
```

```html
<script src="/assets/application-92cab02f6d2d51253880cd98d91f1d0e.js" type="text/javascript" integrity="sha256-WB2pRuy8LdgAZ0aiFxLN8DdfRjKJTc4P4xuEw31iilM=" crossorigin="anonymous"></script>
```

### Settings

To turn off this feature, or to configure it, please have a look at the `production` block in `apps/web/application.rb`

```ruby
module Web
  class Application < Hanami::Application
    configure :production do
      assets do
        # ...
        subresource_integrity :sha256
      end
    end
  end
end
```

By removing or commenting that line, the feature is turned off.

We can choose one or more checksum algorithms:

```ruby
subresource_integrity :sha256, :sha512
```

With this setting, Hanami will render `integrity` HTML attribute with two values: one for `SHA256` and one for `SHA512`.

```html
<script src="/assets/application-92cab02f6d2d51253880cd98d91f1d0e.js" type="text/javascript" integrity="sha256-WB2pRuy8LdgAZ0aiFxLN8DdfRjKJTc4P4xuEw31iilM= sha512-4gegSER1uqxBvmlb/O9CJypUpRWR49SniwUjOcK2jifCRjFptwGKplFWGlGJ1yms+nSlkjpNCS/Lk9GoKI1Kew==" crossorigin="anonymous"></script>
```

**Please note** that checksum calculations are CPU intensive, so adding an additional `subresource_integrity` scheme will extend the time it takes to _precompile assests_, and therefore deploy. We suggest leaving the default setting (`:sha256`).
