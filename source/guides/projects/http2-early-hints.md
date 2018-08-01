---
title: Guides - HTTP/2 Early Hints
version: 1.2
---

# HTTP/2 Early Hints

A web page may link to external resources such as stylesheets, or images (assets).
With HTTP/1.1 the browser parses the HTML and for each link, it downloads the asset and eventually take an action on it: renders an image or evaluate JavaScript code.
With HTTP/2 introduced an enhancement: the server can proactively "push" in parallel both the HTML payload **and** the some assets to the browser. This workflow is allowed due to the HTTP/2 TCP connections are multiplexed. That means many communications can happen at the same time.

Unfortunately HTTP/2 adoption is still slow, so the IETF "backported" this workflow to HTTP/1.1 as well, by introducing the HTTP status [`103 Early Hints`](https://datatracker.ietf.org/doc/rfc8297/).
In this case the server sends **one or more HTTP responses for a single request**. The last one must be the traditional `200 OK` that returns the HTML of the page, whereas the first `n` can include a special header `Link` to tell the browser to fetch the asset ahead of time.

## Setup

As first thing, you need [Puma](http://puma.io/) `3.11.0+` with Early-Hints enabled:

```ruby
# Gemfile
gem "puma"
```

```ruby
# config/puma.rb
early_hints true
```

Then from the project configuration, you can simply enable the feature:

```ruby
# config/environment.rb
Hanami.configure do
  # ...
  early_hints true
end
```

As last step, you need a web server that supports HTTP/2 and Early Hints like [h2o](https://h2o.examp1e.net/).
When you'll start the server and visit the page, javascripts and stylesheets will be pushed (see [Assets helpers](#assets-helpers) section).

### Other web servers

As of today, only Puma supports Early Hints.

## Assets helpers

In order to automatically push your assets, you have to use our [assets helpers](/guides/1.2/helpers/assets).
But given to browser limitations (only up to 100 assets can be pushed), Hanami by default sends stylesheets and javascripts only.

<table class="table table-bordered">
  <thead>
    <tr>
      <th>Helper</th>
      <th>Early Hints asset type</th>
      <th>Pushed by default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>javascript</code></td>
      <td><code>:script</code></td>
      <td>yes</td>
    </tr>
    <tr>
      <td><code>stylesheet</code></td>
      <td><code>:style</code></td>
      <td>yes</td>
    </tr>
    <tr>
      <td><code>favicon</code></td>
      <td><code>:image</code></td>
      <td>no</td>
    </tr>
    <tr>
      <td><code>image</code></td>
      <td><code>:image</code></td>
      <td>no</td>
    </tr>
    <tr>
      <td><code>video</code></td>
      <td><code>:video</code></td>
      <td>no</td>
    </tr>
    <tr>
      <td><code>audio</code></td>
      <td><code>:audio</code></td>
      <td>no</td>
    </tr>
    <tr>
      <td><code>asset_path</code></td>
      <td>N/A</td>
      <td>no</td>
    </tr>
    <tr>
      <td><code>asset_url</code></td>
      <td>N/A</td>
      <td>no</td>
    </tr>
  </tbody>
</table>

You can **opt-in/out** the following types:

### Javascripts

Pushed by default:

```erb
<%= javascript "application" %>
<%= javascript "https://somecdn.test/framework.js", "dashboard" %>
```

Opt-out:

```erb
<%= javascript "application", push: false %>
<%= javascript "https://somecdn.test/framework.css", "dashboard", push: false %>
```

### Stylesheets

Pushed by default:

```erb
<%= stylesheet "application" %>
<%= stylesheet "https://somecdn.test/framework.css", "dashboard" %>
```

Opt-out:

```erb
<%= stylesheet "application", push: false %>
<%= stylesheet "https://somecdn.test/framework.css", "dashboard", push: false %>
```

### Favicon

Opt-in:

```erb
<%= favicon "favicon.ico", push: :image %>
```

### Image

Opt-in:

```erb
<%= image "avatar.png", push: :image %>
```

### Audio

Opt-in:

```erb
<%= audio "song.ogg", push: true %>
```

Block syntax (pushes only `song.ogg`):

```erb
<%=
  audio do
    text "Your browser does not support the audio tag"
    source src: asset_path("song.ogg", push: :audio), type: "audio/ogg"
    source src: asset_path("song.wav"), type: "audio/wav"
  end
%>
```

### Video

Opt-in:

```erb
<%= video "movie.mp4", push: true %>
```

Block syntax (pushes only `movie.mp4`):

```erb
<%=
  video do
    text "Your browser does not support the video tag"
    source src: asset_path("movie.mp4", push: :video), type: "video/mp4"
    source src: asset_path("movie.ogg"), type: "video/ogg"
  end
%>
```

### Asset path

```erb
<%= asset_path "application.js", push: :script %>
```

### Asset URL

```erb
<%= asset_url "https://somecdn.test/framework.js", push: :script %>
```

## Demo project

If you're looking for a full working example, please check this [demo project](https://github.com/jodosha/hall_of_fame).
