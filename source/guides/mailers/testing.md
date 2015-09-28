---
title: Lotus - Guides - Mailers Testing
---

# Testing

During development and testing we don't want to accidentally send emails to the real world.
The [delivery method](/guides/mailers/delivery) for these two envs is set to `:test`.

In order to assert that a mailer sent a message, we can look at `Lotus::Mailer.deliveries`.
It's an array of messages that the framework pretended to deliver during a test.
Please make sure to **clear** them in testing setup.

```ruby
# spec/bookshelf/mailers/welcome_spec.rb
require 'spec_helper'

describe Mailers::Welcome do
  before do
    Lotus::Mailer.deliveries.clear
  end

  let(:user) { ... }

  it "delivers welcome email" do
    Mailers::Welcome.deliver(user: user)
    mail = Lotus::Mailer.deliveries

    mail.to.must_equal             [user.email]
    mail.body.encoded.must_include "Hello, #{ user.name }"
  end
end
```
