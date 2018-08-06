---
title: Guides - Mailers Overview
version: 1.2
---

# Overview

A mailer is an object that's responsible to deliver a mail message, by rendering one or more templates.

For simplicity, each mailer can handle **only one use case (feature)**.
If in our application we need to send emails for several features like: _"confirm your email address"_ or _"forgot password"_, we will have `Mailers::ConfirmEmailAddress` and `Mailers::ForgotPassword` **instead** of a generic `UserMailer` that manages all these use cases.

## A Simple Mailer

Hanami ships a generator that creates a mailer, two templates and the test code.

```shell
% hanami generate mailer welcome
    create  spec/bookshelf/mailers/welcome_spec.rb
    create  lib/bookshelf/mailers/welcome.rb
    create  lib/bookshelf/mailers/templates/welcome.html.erb
    create  lib/bookshelf/mailers/templates/welcome.txt.erb
```

Let's see how a mailer is structured:

```ruby
# lib/bookshelf/mailers/welcome.rb
class Mailers::Welcome
  include Hanami::Mailer
end
```

<p class="convention">
  All the mailers are available under the <code>Mailers</code> namespace.
</p>

