---
title: Guides - Mailers Basic Usage
version: 1.1
---

# Basic Usage

In the [previous section](/guides/1.1/mailers/overview), we generated a mailer, let's use it.

## Information

Firstly, we need to specify sender and recipient(s) and the subject of the email.
For this purpose a mailer exposes three mandatory methods: `.from`, `.to`, `.subject` and two optional: `.cc`, `.bcc`.

They all accept a string, but `.to` can also accept an array of strings in order to set multiple recipients.

```ruby
class Mailers::Welcome
  include Hanami::Mailer

  from    'noreply@bookshelf.org'
  to      'user@example.com'
  subject 'Welcome to Bookshelf'
end
```

<p class="warning">
  Both <code>.from</code> and <code>.to</code> MUST be specified when we deliver an email.
</p>

<p class="notice">
  An email subject isn't mandatory, but it's a good practice to set this information.
</p>

You may have noticed that have a hardcoded value can be useful to set the sender, but it doesn't work well for the rest of the details.

If you pass a **symbol as an argument**, it will be interpreted as a **method** that we want to use for that information.


```ruby
class Mailers::Welcome
  include Hanami::Mailer

  from    'noreply@bookshelf.org'
  to      :recipient
  subject :subject

  private

  def recipient
    user.email
  end

  def subject
    "Welcome #{ user.name }!"
  end
end
```

<p class="notice">
  There is NOT a convention between the name of the methods and their corresponding DSL.
</p>

<p class="notice">
  We suggest to use always private methods for these informations, unless they need to be available from the templates.
</p>

## Context

### Locals

In the previous section, we have referenced an `user` variable, where does it come from?
Similarly to a [view](/guides/1.1/views/basic-usage), a mailer can have a set of _locals_ that can be passed as an argument in order to make them available during the rendering.

```ruby
u = User.new(name: 'Luca', email: 'luca@example.com')
Mailers::Welcome.deliver(user: u)
```

We can specify as many locals as we want, the key that we use for each of them it's the same that we use to reference that object.
For instance, we passed `:user` key, and we can use `user` in the mailer and its associated templates.

<p class="warning">
  The following keys for locals are RESERVED: <code>:format</code> and <code>:charset</code>.
</p>

### Scope

All the public methods defined in a mailer are accessible from the templates:

```ruby
# lib/bookshelf/mailers/welcome.rb
class Mailers::Welcome
  include Hanami::Mailer

  # ...

  def greeting
    "Ahoy"
  end
end
```

```erb
# lib/bookshelf/mailers/templates/welcome.html.erb
<h2><%= greeting %></h2>
```
