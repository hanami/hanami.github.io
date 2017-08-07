---
title: Guides - Assets Helpers
version: head
---

## Assets Helpers

These helpers are HTML5 generators that target specific assets features.

They are following the settings of the application that uses them.
For instance, if we have a project with two applications `Web` and `Admin` mounted at `/` and `/admin`, respectively, all the asset URLs will respect these prefixes.

They also respect [_Fingerprint mode_](/guides/head/assets/overview#fingerprint-mode) and [_CDN mode_](/guides/head/assets/content-delivery-network) for each application.

The following helpers are available for views and templates:

  * `javascript`
  * `stylesheet`
  * `favicon`
  * `image`
  * `video`
  * `audio`
  * `asset_path`
  * `asset_url`

## Usage

### `javascript`

It generates a `<script>` tag for the given source(s).
A source can be the file name without the extension, or an absolute URL.

```erb
<%= javascript 'https://code.jquery.com/jquery-2.1.1.min.js', 'application' %>
```

```html
<script src="https://code.jquery.com/jquery-2.1.1.min.js" type="text/javascript"></script>
<script src="/assets/application.js" type="text/javascript"></script>
```

Alternatively, it accepts **only one** source and a Hash to represent HTML attributes.

```erb
<%= javascript 'application', async: true %>
```

```html
<script src="/assets/application.js" type="text/javascript" async="true"></script>
```

### `stylesheet`

It generates a `<link>` tag for the given source(s).
A source can be the file name without the extension, or an absolute URL.

```erb
<%= stylesheet 'reset', 'grid', 'main' %>
```

```html
<link href="/assets/reset.css" type="text/css" rel="stylesheet">
<link href="/assets/grid.css" type="text/css" rel="stylesheet">
<link href="/assets/main.css" type="text/css" rel="stylesheet">
```

Alternatively, it accepts **only one** source and a Hash to represent HTML attributes.

```erb
<%= stylesheet 'application', crossorigin: 'anonymous' %>
```

```html
<link href="/assets/application.css" type="text/css" rel="stylesheet" crossorigin="anonymous">
```

### `favicon`

It generates a `<link>` tag for the application favicon.

By default it looks at `/assets/favicon.ico`.

```erb
<%= favicon %>
```

```html
<link href="/assets/favicon.ico" rel="shortcut icon" type="image/x-icon">
```

We can specify a source name and HTML attributes.

```erb
<%= favicon 'favicon.png', rel: 'icon', type: 'image/png' %>
```

```html
<link rel="icon" type="image/png" href="/assets/favicon.png">
```

### `image`

It generates a `<img>` tag for the given source.
A source can be the file name with the extension, or an absolute URL.

The `alt` attribute is set automatically from file name.

```erb
<%= image 'logo.png' %>
```

```html
<img src="/assets/logo.png" alt="Logo">
```

We can specify arbitrary HTML attributes.

```erb
<%= image 'logo.png', alt: 'Application Logo', id: 'logo', class: 'background' %>
```

```html
<img src="/assets/logo.png" alt="Application Logo" id="logo" class="background">
```

### `video`

It generates a `<video>` tag for the given source.
A source can be the file name with the extension, or an absolute URL.

```erb
<%= video 'movie.mp4' %>
```

```html
<video src="/assets/movie.mp4"></video>
```

We can specify arbitrary HTML attributes.

```erb
<%= video 'movie.mp4', autoplay: true, controls: true %>
```

```html
<video autoplay="autoplay" controls="controls" src="/assets/movie.mp4"></video>
```

It accepts a block for fallback message.

```erb
<%=
  video('movie.mp4') do
    "Your browser does not support the video tag"
  end
%>
```

```html
<video src="/assets/movie.mp4">
  Your browser does not support the video tag
</video>
```

It accepts a block to specify tracks.

```erb
<%=
  video('movie.mp4') do
    track kind: 'captions', src: asset_path('movie.en.vtt'), srclang: 'en', label: 'English'
  end
%>
```

```html
<video src="/assets/movie.mp4">
  <track kind="captions" src="/assets/movie.en.vtt" srclang="en" label="English">
</video>
```

It accepts a block to specify multiple sources.

```erb
<%=
  video do
    text "Your browser does not support the video tag"
    source src: asset_path('movie.mp4'), type: 'video/mp4'
    source src: asset_path('movie.ogg'), type: 'video/ogg'
  end
%>
```

```html
<video>
  Your browser does not support the video tag
  <source src="/assets/movie.mp4" type="video/mp4">
  <source src="/assets/movie.ogg" type="video/ogg">
</video>
```

### `audio`

It generates a `<audio>` tag for the given source.
A source can be the file name with the extension, or an absolute URL.

```erb
<%= audio 'song.ogg' %>
```

```html
<audio src="/assets/song.ogg"></audio>
```

We can specify arbitrary HTML attributes.

```erb
<%= audio 'song.ogg', autoplay: true, controls: true %>
```

```html
<audio autoplay="autoplay" controls="controls" src="/assets/song.ogg"></audio>
```

It accepts a block for fallback message.

```erb
<%=
  audio('song.ogg') do
    "Your browser does not support the audio tag"
  end
%>
```

```html
<audio src="/assets/song.ogg">
  Your browser does not support the audio tag
</audio>
```

It accepts a block to specify tracks.

```erb
<%=
  audio('song.ogg') do
    track kind: 'captions', src: asset_path('movie.en.vtt'), srclang: 'en', label: 'English'
  end
%>
```

```html
<audio src="/assets/song.ogg">
  <track kind="captions" src="/assets/movie.en.vtt" srclang="en" label="English">
</audio>
```

It accepts a block to specify multiple sources.

```erb
<%=
  audio do
    text "Your browser does not support the audio tag"
    source src: asset_path('song.ogg'), type: 'audio/mp4'
    source src: asset_path('movie.ogg'), type: 'audio/ogg'
  end
%>
```

```html
<audio>
  Your browser does not support the audio tag
  <source src="/assets/song.ogg" type="audio/mp4">
  <source src="/assets/movie.ogg" type="audio/ogg">
</audio>
```

### `asset_path`

Returns a **relative URL** for the given asset name.

**This is used internally by the other helpers, so the following rules apply to all of them.**

#### Asset Name

When the argument is a relative name, it returns a relative URL.

```erb
<%= asset_path 'application.js' %>
```

```html
/assets/application.js
```

#### Absolute URL

When an absolute URL is given, it's **always** returned as it is, even if _Fingerprint_ or _CDN_ mode are on.

```erb
<%= asset_path 'https://code.jquery.com/jquery-2.1.1.min.js' %>
```

```html
https://code.jquery.com/jquery-2.1.1.min.js
```

#### Fingerprint Mode

When [_Fingerprint Mode_](/guides/head/assets/overview#fingerprint-mode) is on (usually in _production_ env), the relative URL contains a checksum suffix.

```erb
<%= asset_path 'application.css' %>
```

```html
/assets/application-9ab4d1f57027f0d40738ab8ab70aba86.css
```

#### CDN Mode

When [_CDN Mode_](/guides/head/assets/content-delivery-network) is on (usually in _production_ env), it returns an absolute URL that reference the CDN settings.

```erb
<%= asset_path 'application.css' %>
```

```html
https://123.cloudfront.net/assets/application-9ab4d1f57027f0d40738ab8ab70aba86.css
```

<p class="notice">
  In the example above we have a checksum suffix, because CDN vendors suggest to use this strategy while using their product.
</p>

### `asset_url`

Returns an **absolute URL** for the given asset name.

To build the URL it uses `scheme`, `host`, `port` from your application settings in combination of CDN settings.

#### Asset Name

When the argument is a relative name, it returns an absolute URL.

```erb
<%= asset_url 'application.js' %>
```

```html
https://bookshelf.org/assets/application.js
```

#### Absolute URL

When an absolute URL is given, it's **always** returned as it is, even if _Fingerprint_ or _CDN_ mode are on.

```erb
<%= asset_url 'https://code.jquery.com/jquery-2.1.1.min.js' %>
```

```html
https://code.jquery.com/jquery-2.1.1.min.js
```

#### Fingerprint Mode

When [_Fingerprint Mode_](/guides/head/assets/overview#fingerprint-mode) is on (usually in _production_ env), the relative URL contains a checksum suffix.

```erb
<%= asset_url 'application.css' %>
```

```html
https://bookshelf.org/assets/application-9ab4d1f57027f0d40738ab8ab70aba86.css
```

#### CDN Mode

When [_CDN Mode_](/guides/head/assets/content-delivery-network) is on (usually in _production_ env), it returns an absolute URL that reference the CDN settings.

```erb
<%= asset_url 'application.css' %>
```

```html
https://123.cloudfront.net/assets/application-9ab4d1f57027f0d40738ab8ab70aba86.css
```

<p class="notice">
  In the example above we have a checksum suffix, because CDN vendors suggest to use this strategy while using their product.
</p>


## Content Security Policy

When using **absolute URLs as sources** or when we use a CDN, we can run into errors because our browser refute to load assets due to security restrictions (aka _"Content Security Policy"_).

To fix them, we need to adjust security settings in our application.

```ruby
# apps/web/application.rb
module Web
  class Application < Hanami::Application
    configure do
      # ...

      # If we're using our own CDN
      security.content_security_policy "default-src https://123.cloudfront.net;"

      # Or if we're just using jQuery public CDN
      # security.content_security_policy "default-src none; script-src 'self' https://code.jquery.com;"
    end
  end
end
```

To learn more about Content Security Policy usage, please read:

  * [http://content-security-policy.com](http://content-security-policy.com)
  * [https://developer.mozilla.org/en-US/docs/Web/Security/CSP/Using_Content_Security_Policy](https://developer.mozilla.org/en-US/docs/Web/Security/CSP/Using_Content_Security_Policy)
