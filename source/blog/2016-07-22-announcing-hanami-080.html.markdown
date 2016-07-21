---
title: Announcing Hanami v0.8.0
date: 2016-07-22 13:26 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  New validations syntax with predicates, high level rules and error messages.
  JSON logger format, faster static assets serving.
  Subresource Integrity, updated Content Security Policy, and new HTTP security headers.
---

This is the first minor release after the [project rebranding](/blog/2016/01/22/lotus-is-now-hanami.html) that happened a few months ago.

We waited so long to release this version in order to have the largest possible feedback cycle. (Actually, the longest gap in releases since this project was started four years ago!)
We've had a lot of new contributions: new features, bug fixes, and real world experiences.
At this point **we're really close to 1.0**.

In the meantime, we've started tech alliances with [dry-rb](http://dry-rb.org) and [ROM](http://rom-rb.org).
We're working closely with these two amazing projects (and communities) to make the Ruby ecosystem stronger.

As result of this collaboration, today we can ship a new, powerful validation syntax based on [dry-validation](http://dry-rb.org/gems/dry-validation).

## Features

### New Validations Syntax

This new powerful syntax overcomes the limitations that we have reached with the old design: no control on the order of execution and lack of extensibility.
We realized that complex validation rules are hard to describe with DSL options, so we made it possible to express these rules with Ruby macros.

The results are astonishing: besides having better expressiveness, we now guarantee type safety and have better performance.

```ruby
# apps/web/controllers/books/create.rb
module Web::Controllers::Books
  class Create
    include Web::Action

    params do
      required(:book).schema do
        required(:title).filled(:str?)
        required(:price).filled(:float?, gt?: 0.0)
        optional(:sale).filled(:bool?)
      end
    end

    def call(params)
      if params.valid?
        # persist
      else
        self.status = 422
      end
    end
  end
end
```

```ruby
# apps/web/views/books/create.rb
module Web::Views::Books
  class Create
    include Web::View
    template 'books/new'
  end
end
```

```erb
# apps/web/templates/books/new.html.erb
<% unless params.valid? %>
  <div>
    <p>There was a problem</p>
    <ul>
      <% params.error_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
    </ul>
  </div>
<% end %>
```

### Subresource Integrity

A CDN can dramatically improve page speed, but it can potentially open a security breach.
If the CDN that we're using is compromised and serves evil javascript or stylesheet files, we're exposing our users to security attacks like Cross Site Scripting (XSS).

To solve this problem, browsers vendors introduced a defense called [Subresource Integrity](https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity).

When enabled, the browser verifies that the checksum of the downloaded file, matches with the declared one.

#### From A CDN

If we're using jQuery from their CDN, we should find the checksum of the `.js` file on their website and write:

```erb
<%= javascript 'https://code.jquery.com/jquery-3.1.0.min.js', integrity: 'sha256-cCueBR6CsyA4/9szpPfrX3s49M9vUU5BgtiJj06wt/s=' %>
```

The output will be:

```html
<script integrity="sha256-cCueBR6CsyA4/9szpPfrX3s49M9vUU5BgtiJj06wt/s=" src="https://code.jquery.com/jquery-3.1.0.min.js" type="text/javascript" crossorigin="anonymous"></script>
```

#### Local Assets

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

### Security Updates

We've updated our default security settings to support [Content Security Policy](https://content-security-policy.com) 1.1 and 2.0 (1.0 is still supported).

Along with this improvement, we have now turned on two extra security HTTP headers: `X-Content-Type-Options` and `X-XSS-Protection`.

### Misc

New settings for logging: Hanami now supports per environment stream (standard output, file, etc..), level and formatter.
Because of JSON parseability, for the production environment, there is now a JSON formatter for the logger.

## Upgrade Notes

Please have a look at the [upgrade notes for v0.8.0](/guides/upgrade-notes/v080).

## Contributors

We're grateful for each person who contributed to this release.
These lovely people are:

  * [Alexander Gräfe](https://github.com/rickenharp)
  * [Alexandr Subbotin](https://github.com/KELiON)
  * [Andrew De Ponte](https://github.com/cyphactor)
  * [Andrey Deryabin](https://github.com/aderyabin)
  * [Andrey Morskov](https://github.com/accessd)
  * [Anton Davydov](https://github.com/davydovanton)
  * [Ariejan de Vroom](https://github.com/ariejan)
  * [Artem Nistratov](https://github.com/ADone)
  * [Beat](https://github.com/beatrichartz)
  * [Bernardo Farah](https://github.com/berfarah)
  * [Cang Ta](https://github.com/hoksilato)
  * [Dane Balia](https://github.com/daneb)
  * [Eric Freese](https://github.com/ericfreese)
  * [Erol Fornoles](https://github.com/Erol)
  * [Felipe Espinoza](https://github.com/fespinoza)
  * [Hiếu Nguyễn](https://github.com/hieuk09)
  * [Josh Bodah](https://github.com/jbodah)
  * [Kadu Ribeiro](https://github.com/duduribeiro)
  * [Karim Tarek](https://github.com/karimmtarek)
  * [Leonardo Saraiva](https://github.com/vyper)
  * [Lucas Amorim](https://github.com/lucasallan)
  * [Mahesh](https://github.com/maheshm)
  * [Marcello Rocha](https://github.com/mereghost)
  * [Matt McFarland](https://github.com/vanetix)
  * [Matthew Gibbons](https://github.com/accuser)
  * [Maxim Dorofienko](https://github.com/mdorfin)
  * [Neil Matatall](https://github.com/oreoshake)
  * [Nicola Racco](https://github.com/nicolaracco)
  * [Nikita Shilnikov](https://github.com/flash-gordon)
  * [Nikolay Shebanov](https://github.com/killthekitten)
  * [Ozawa Sakuro](https://github.com/sakuro)
  * [Pascal Betz](https://github.com/pascalbetz)
  * [Rogério Ramos](https://github.com/habutre)
  * [Rogério Zambon](https://github.com/rogeriozambon)
  * [Sean Collins](https://github.com/cllns)
  * [Sebastjan Hribar](https://github.com/sebastjan-hribar)
  * [Semyon Pupkov](https://github.com/artofhuman)
  * [Semyon Pupkov](https://github.com/artofhuman)
  * [Steve Hook](https://github.com/stevehook)
  * [TheSmartnik](https://github.com/TheSmartnik)
  * [Tran Duy Khoa](https://github.com/duykhoa)
  * [Vasilis Spilka](https://github.com/vasspilka)
  * [akhramov](https://github.com/akhramov)
  * [deepj](https://github.com/deepj)
  * [nessur](https://github.com/nessur)

Thank you all!
