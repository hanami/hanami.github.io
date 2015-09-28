---
title: Lotus - Guides - Mailers Delivery
---

# Delivery

## Multipart Delivery

By default a mailer delivers a multipart email, that has a HTML and a text part.
This is the reason why the generators creates two templates.

To render both the templates and deliver them as a multipart message, we simply do:

```ruby
Mailers::Welcome.deliver
```

Lotus mailers are flexible enough to adapt to several scenarios.

## Single Part Delivery

Let's say in our application users can opt for HTML or textual emails.
According to this configuration, we want to selectively send only the wanted format:

```ruby
Mailers::Welcome.deliver(format: :html)
# or
Mailers::Welcome.deliver(format: :txt)
```

By using only one format, it will render and delivery only the specified template.

## Remove Templates

If in our application, we want only to delivery HTML templates, we can **safely** remove textual templates (`.txt` extension) and every time we will do `Mailers::Welcome.deliver` it will only send the HTML message.

The same priciple applies if we want only to send textual emails, just remove HTML templates (`.html` extension).

<p class="warning">
  At the delivery time, a mailer MUST have at least one template available.
</p>

## Configuration

In order to specify the gateway to use for our email messages, we can use `delivery_method` configuration.

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
# lib/bookshelf.rb
# ...
Lotus::Mailer.configure do
  # ...
  delivery_method do
    production :stmp,
      address:              "smtp.gmail.com",
      port:                 587,
      domain:               "bookshelf.org",
      user_name:            ENV['SMTP_USERNAME'],
      password:             ENV['SMTP_PASSWORD'],
      authentication:       "plain",
      enable_starttls_auto: true
  end
end.load!
```

For advanced configurations, please have a look at `mail` [gem](https://github.com/mikel/mail) by Mikel Lindsaar.
At the low level, **Lotus::Mailer** uses this rock solid library.

Because Lotus uses `mail` gem, which is a _de facto_ standard for Ruby, we can have interoperability with all the most common gateways vendors.
[Sendgrid](https://devcenter.heroku.com/articles/sendgrid#ruby-rails), [Mandrill](https://devcenter.heroku.com/articles/mandrill#sending-with-smtp), [Postmark](https://devcenter.heroku.com/articles/postmark#sending-emails-via-the-postmark-smtp-interface) and [Mailgun](https://devcenter.heroku.com/articles/mailgun#sending-emails-via-smtp) just to name a few, use SMTP and have detailed setup guides.

### Custom Methods

If we need to a custom delivery workflow, we can pass a class to the configuration.

Here's an example on how to use [Mandrill API](https://mandrillapp.com/api/docs/) to deliver emails.

```ruby
# lib/bookshelf.rb
# ...
require 'lib/mailers/mandrill_delivery_method'

Lotus::Mailer.configure do
  # ...
  delivery_method do
    production MandrillDeliveryMethod
      api_key: ENV['MANDRILL_API_KEY']
  end
end.load!
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

  def send(raw_message)
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
