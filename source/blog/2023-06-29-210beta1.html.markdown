---
title: Announcing Hanami v2.1.0.beta1
date: 2023-06-29 09:00 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  Introducing hanami-view and sharing our plans for v2.1
---

Since the release of 2.0, we’ve been hard at work completing our vision for full stack Hanami apps. Today we’re excited to advance our view layer and introduce hanami-view with the release of 2.1.0.beta1.

Just like our actions, views are standalone, callable objects. They can work with their arguments and dependencies to prepare exposures to pass to a template for rendering:

```ruby
# app/views/posts/index.rb
module MyApp
  module Views
    module Posts
      class Index < MyApp::View
        include Deps["posts_repo"]

        expose :posts do |page:|
          posts_repo.listing(page:)
        end
      end
    end
  end
end
```

```html
<h1>Posts</h1>

<%= posts.each do |post| %>
  <h2><%= post.title %></h2>
<% end %>
```

Views are automatically paired with matching actions, so they're ready for you to render:

```ruby
# app/actions/posts/index.rb

module MyApp
  module Actions
    module Posts
      class Index < MyApp::Action
        def handle(request, response)
          request.params => {page:}

          # view is a ready-to-go instance of MyApp::Views::Posts::Index
          response.render(view, page:)
        end
      end
    end
  end
end
```

Hanami views are built on top of [Tilt](https://github.com/jeremyevans/tilt), giving them support for a wide range of template engines. For HTML templates, we provide first-party support for ERB (using a brand new implementation for hanami-view), Haml and Slim.

Hanami will generate matching views when you generate your actions with the `hanami generate action` command. You can also generate views directly via `hanami generate view`.

Along with views, we’re also introducing a range of built-in helpers, giving you convenient ways to create forms and programatically generate HTML. You can also provide your own helpers inside a `Views::Helpers` module within each app and slice namespace.

You can write your own helpers using natural, expressive Ruby, including straightforward yielding of blocks:

```ruby
# app/views/helpers.rb

module MyApp
  module Views
    module Helpers
      # Feel free to organise your helpers into submodules as appropriate

      def warning_box
        # `tag` is our built-in HTML builder helper
        tag.div(class: "warning") do
          # Yielding implicitly captures content from the block in the template
          yield
        end
      end
    end
  end
end
```

```html
<h1>Posts</h1>

<%= warning_box do %>
  <h2>This section is under construction</h2>
<% end %>
```

hanami-view is the successor to dry-view, a view system honed over many years of real-world use. Along with the above, it includes even more powerful tools for helping you build a clean and maintainable view layer, such as custom view parts and scopes.

We’re working on updating our getting started guide to include an introduction to views, and we’ll release this as soon as its available.

In the meantime, we’re making this 2.1 beta release so you can give views a try and make sure they’re ready for prime time!

## What’s included?

Today we’re releasing the following gems:

- hanami v2.1.0.beta1
- hanami-cli v2.1.0.beta1
- hanami-controller v2.1.0.beta1
- hanami-router v2.1.0.beta1
- hanami-validations v2.1.0.beta1
- hanami-utils v2.1.0.beta1
- hanami-view v2.1.0.beta1
- hanami-reloader v2.1.0.beta1
- hanami-rspec v2.1.0.beta1
- hanami-webconsole v2.1.0.beta1

For specific changes in this beta release, please see each gem’s own CHANGELOG.

## How can I try it?

```shell
> gem install hanami --pre
> hanami new my_app
> cd my_app
> bundle exec hanami --help
```

## What’s next for 2.1?

Alongside our work on views, we’ve been preparing Hanami’s front end assets support. This will be based on esbuild, will integrate seamlessly with our views, and even support you splitting your front end assets by slice.

We plan to release this as hanami-assets in an upcoming Hanami v2.0.beta2 release. At this point, you’ll be able to build Hanami apps with a complete front end.

After a short testing period, we’ll release all of these as 2.1.0.

## Contributors

Thank you to these fine people for contributing to this release!


- [Luca Guidi](https://github.com/jodosha)
- [Tim Riley](https://github.com/timriley)
- [dsinero](https://github.com/dsinero)
- [Masanori Ohnishi](https://github.com/MasanoriOnishi)

## Thank you

Thank you as always for supporting Hanami!

We’re excited to be expanding the Hanami vision again, and we can’t wait to hear from you about this beta! 🌸
