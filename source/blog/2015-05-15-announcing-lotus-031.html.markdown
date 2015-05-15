---
title: Announcing Lotus v0.3.1
date: 2015-05-15 15:09 UTC
tags: announcements
author: Luca Guidi
image: true
excerpt: >
  Lotus patch release: RESTful nested resource(s), dirty tracking and timestamps for entities, improved code generators, bug fixes.
---

## Features

This patch release ships new features and improved code generators.

### RESTful nested resource(s)

RESTful resource(s) can be nested with infinite levels.

```ruby
# apps/web/config/routes.rb
resources :users do
  resource  :avatar
  resources :events
end
```

This generates the following routes:

```
% lotus routes

     new_user_avatar GET, HEAD  /users/:user_id/avatar/new
         user_avatar POST       /users/:user_id/avatar
         user_avatar GET, HEAD  /users/:user_id/avatar
    edit_user_avatar GET, HEAD  /users/:user_id/avatar/edit
         user_avatar PATCH      /users/:user_id/avatar
         user_avatar DELETE     /users/:user_id/avatar
         user_events GET, HEAD  /users/:user_id/events
      new_user_event GET, HEAD  /users/:user_id/events/new
         user_events POST       /users/:user_id/events
          user_event GET, HEAD  /users/:user_id/events/:id
     edit_user_event GET, HEAD  /users/:user_id/events/:id/edit
          user_event PATCH      /users/:user_id/events/:id
          user_event DELETE     /users/:user_id/events/:id
               users GET, HEAD  /users
            new_user GET, HEAD  /users/new
               users POST       /users
                user GET, HEAD  /users/:id
           edit_user GET, HEAD  /users/:id/edit
                user PATCH      /users/:id
                user DELETE     /users/:id
```

The corresponding endpoints are actions like `Web::Controllers::Users::Avatar::Create` or `Web::Controllers::Users::Events::Show`.

### Dirty Tracking

Entities can now track changed attributes and dirty status.

```ruby
# lib/bookshelf/entities/user.rb
class User
  include Lotus::Entity
  include Lotus::Entity::DirtyTracking
  attributes :name, :age
end
```

This new feature is activated by including `Lotus::Entity::DirtyTracking`.
It exposes `#changed?` and `#changed_attributes`.

```ruby
# Usage
user = User.new(name: 'L')
user.changed? # => false

user.age = 33
user.changed?           # => true
user.changed_attributes # => {:age=>33}

user = UserRepository.create(user)
user.changed? # => false

user.update(name: 'Luca')
user.changed?           # => true
user.changed_attributes # => {:name=>"Luca"}

user = UserRepository.update(user)
user.changed? # => false

result = UserRepository.find(user.id)
result.changed? # => false
```

When an entity is initialized and after it's created or updated, the state is clean.
If we mutate the state with an assigment or with `Entity#update`, `#changed?` returns true.

### Timestamps

If an entity has `:created_at` and/or `:updated_at` attributes, when it's persisted, the repository will take care of manage these values for us.

```ruby
# lib/bookshelf/entities/user.rb
class User
  include Lotus::Entity
  attributes :name, :created_at, :updated_at
end
```

We have mapped both these attributes as `DateTime`.

```ruby

user = User.new(name: 'L')
puts user.created_at # => nil
puts user.updated_at # => nil

user = UserRepository.create(user)
puts user.created_at.to_s # => "2015-05-15T10:12:20+00:00"
puts user.updated_at.to_s # => "2015-05-15T10:12:20+00:00"

user.name = "Luca"
user      = UserRepository.update(user)
puts user.created_at.to_s # => "2015-05-15T10:12:20+00:00"
puts user.updated_at.to_s # => "2015-05-15T10:12:23+00:00"
```

### Application Generator

Lotus default architecture is named [_Container_](https://github.com/lotus/lotus#container-architecture), as it allows to run multiple Lotus (and Rack) applications within the same Ruby process.

When we generate a new project with `lotus new bookshelf`, it creates a default application named `Web`, under `apps/web`.
This architecture enforces a separation between components and it will make our life easier [if we want extract microservices](http://lucaguidi.com/2015/05/05/lotus-and-microservices.html) at a later stage.

If we want to introduce a new component in our container (eg. an admin pane, a metrics dashboard), we can use the new application generator.

```
lotus generate app admin
```

This command will add a new application named `Admin` under `apps/admin`, and it will be available under the `/admin` URL namespace.

### Model Generator

This last feature is really helpful while developing our domain model.
It generates an **entity**, a **repository** and the related **test files**.

```shell
% lotus generate model user
  create  lib/bookshelf/entities/user.rb
  create  lib/bookshelf/repositories/user_repository.rb
  create  spec/bookshelf/entities/user_spec.rb
  create  spec/bookshelf/repositories/user_repository_spec.rb
```

## What's Next

New features such as migrations, form helpers and improved security are under development right now.
We're pushing to ship soon.

<div style="display: inline">
  <iframe src="https://ghbtns.com/github-btn.html?user=lotus&repo=lotus&type=star&count=true&size=large" frameborder="0" scrolling="0" width="160px" height="30px"></iframe>

  <a href="https://news.ycombinator.com/submit" class="hn-button" data-title="Announcing Lotus v0.3.1" data-url="http://lotusrb.org/blog/2015/05/15/announcing-lotus-031.html" data-count="horizontal" data-style="facebook">Vote on Hacker News</a>
  <script type="text/javascript">var HN=[];HN.factory=function(e){return function(){HN.push([e].concat(Array.prototype.slice.call(arguments,0)))};},HN.on=HN.factory("on"),HN.once=HN.factory("once"),HN.off=HN.factory("off"),HN.emit=HN.factory("emit"),HN.load=function(){var e="hn-button.js";if(document.getElementById(e))return;var t=document.createElement("script");t.id=e,t.src="//hn-button.herokuapp.com/hn-button.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(t,n)},HN.load();</script>
  <script type="text/javascript">
    reddit_url = "http://lotusrb.org/blog/2015/05/15/announcing-lotus-031.html";
  </script>
  <script type="text/javascript" src="//www.redditstatic.com/button/button1.js"></script>
</div>
