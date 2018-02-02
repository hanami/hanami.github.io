---
title: Guides - Mailers Delivery
version: 1.1
---

# Delivery

## Multipart Delivery

By default a mailer delivers a multipart email, that has a HTML and a text part.
This is the reason why the generator creates two templates.

To render both the templates and deliver them as a multipart message, we simply do:

```ruby
Mailers::Welcome.deliver
```

Hanami mailers are flexible enough to adapt to several scenarios.

## Single Part Delivery

Let's say in our application users can opt for HTML or textual emails.
According to this configuration, we want to selectively send only the wanted format:

```ruby
Mailers::Welcome.deliver(format: :html)
# or
Mailers::Welcome.deliver(format: :txt)
```

By using only one format, it will render and deliver only the specified template.

## Remove Templates

If in our application, we want only to deliver HTML templates, we can **safely** remove textual templates (`.txt` extension) and every time we will do `Mailers::Welcome.deliver` it will only send the HTML message.

The same principle applies if we want only to send textual emails, just remove HTML templates (`.html` extension).

<p class="warning">
  At the delivery time, a mailer MUST have at least one template available.
</p>

## Configuration

In order to specify the gateway to use for our email messages, we can use `delivery` configuration.

### Built-in Methods

It accepts a symbol that is translated into a delivery strategy:

  * Exim (`:exim`)
  * Sendmail (`:sendmail`)
  * SMTP (`:smtp`, for local SMTP installations)
  * SMTP Connection (`:smtp_connection`, via `Net::SMTP` - for remote SMTP installations)
  * Test (`:test`, for testing purposes)

It defaults to SMTP (`:smtp`) for production environment, while `:test` is automatically set for development and test.

The second optional argument is a set of arbitrary configurations that we want to pass to the configuration:

```ruby
# config/environment.rb
# ...
Hanami.configure do
  # ...

  mailer do
    root Hanami.root.join("lib", "bookshelf", "mailers")

    # See http://hanamirb.org/guides/1.1/mailers/delivery
    delivery :test
  end

  # ...

  environment :production do
    # ...

    mailer do
      delivery :smtp, address: ENV['SMTP_HOST'], port: ENV['SMTP_PORT']
    end
  end
end
```

For advanced configurations, please have a look at `mail` [gem](https://github.com/mikel/mail) by Mikel Lindsaar.
At the low level, **Hanami::Mailer** uses this rock solid library.

Because Hanami uses `mail` gem, which is a _de facto_ standard for Ruby, we can have interoperability with all the most common gateways vendors.
[Sendgrid](https://devcenter.heroku.com/articles/sendgrid#ruby-rails), [Mandrill](https://devcenter.heroku.com/articles/mandrill#sending-with-smtp), [Postmark](https://devcenter.heroku.com/articles/postmark#sending-emails-via-the-postmark-smtp-interface) and [Mailgun](https://devcenter.heroku.com/articles/mailgun#sending-emails-via-smtp) just to name a few, use SMTP and have detailed setup guides.

### Custom Methods

If we need to a custom delivery workflow, we can pass a class to the configuration.

Here's an example on how to use [Mandrill API](https://mandrillapp.com/api/docs/) to deliver emails.

```ruby
# config/environment.rb
# ...
require 'lib/mailers/mandrill_delivery_method'

Hanami.configure do
  # ...

  environment :production do
    # ...

    mailer do
      delivery MandrillDeliveryMethod, api_key: ENV['MANDRILL_API_KEY']
    end
  end
end
```

The object MUST respond to `#initialize(options = {})` and to `#deliver!(mail)`, where `mail` is an instance of [`Mail::Message`](https://github.com/mikel/mail/blob/master/lib/mail/mail.rb).

```ruby
class MandrillDeliveryMethod
  def initialize(options)
    @api_key = options.fetch(:api_key)
  end

  def deliver!(mail)
    send convert(mail)
  end

  private

  def send(message)
    gateway.messages.send message
  end

  def convert(mail)
    # Convert a Mail::Message instance into a Hash structure
    # See https://mandrillapp.com/api/docs/messages.ruby.html
  end

  def gateway
    Mandrill::API.new(@api_key)
  end
end
```

<p class="notice">
  Please notice that this is only an example that illustrates custom policies. If you want to use Mandrill, please prefer SMTP over this strategy.
</p>
