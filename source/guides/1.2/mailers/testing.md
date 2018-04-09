---
title: Guides - Mailers Testing
version: 1.1
---

# Testing

During development and testing we don't want to accidentally send emails to the real world.
The [delivery method](/guides/1.1/mailers/delivery) for these two envs is set to `:test`.

In order to assert that a mailer sent a message, we can look at `Hanami::Mailer.deliveries`.
It's an array of messages that the framework pretended to deliver during a test.
Please make sure to **clear** them in testing setup.

```ruby
# spec/bookshelf/mailers/welcome_spec.rb
require 'spec_helper'

describe Mailers::Welcome do
  before { Hanami::Mailer.deliveries.clear }

  let(:user) { ... }

  it "delivers welcome email" do
    Mailers::Welcome.deliver(user: user)
    mail = Hanami::Mailer.deliveries.last

    expect(mail.to).to           eq([user.email])
    expect(mail.body.encoded).to eq("Hello, #{ user.name }")
  end
end
```
