---
title: Guides - Project Security
version: 1.0
---

# Security

Modern web development has many challenges, and of those security is both very important and often under-emphasized.

Hanami provides ways to secure from most common vulnerabilities. Security options can be configured in <code>application.rb</code>.

# X-Frame-Options

X-Frame-Options is a HTTP header supported by modern browsers. It determines if a web page can or cannot be included via *&lt;frame&gt;* and *&lt;iframe&gt;* tags by untrusted domains.

Web applications can send this header to prevent Clickjacking attacks:

```ruby
# Denies all untrusted domains
security.x_frame_options 'DENY'
```

```ruby
# Allows iframes on example.com
security.x_frame_options 'http://example.com'
```

# X-Content-Type-Options

X-Content-Type-Options prevents browsers from interpreting files as something else than declared by the content type in the HTTP headers.

```ruby
# Will prevent the browser from MIME-sniffing a response away from the declared content-type.
security.x_content_type_options 'nosniff'
```

# X-XSS-Protection

X-XSS-Protection is a HTTP header to determine the behavior of the browser in case an XSS attack is detected.

```ruby
# Filter disabled
security.x_xss_protection '0'
```

```ruby
# Filter enabled. If a cross-site scripting attack is detected, in order to stop the attack,
# the browser will sanitize the page
security.x_xss_protection '1'
```


```ruby
# Filter enabled. Rather than sanitize the page, when a XSS attack is detected,
# the browser will prevent rendering of the page
security.x_xss_protection '1; mode=block'
```


```ruby
# The browser will sanitize the page and report the violation.
# This is a Chromium function utilizing CSP violation reports to send details to a URI of your choice
security.x_xss_protection '1; report=http://[YOURDOMAIN]/your_report_URI'
```

# Content-Security-Policy
Content-Security-Policy (CSP) is a HTTP header supported by modern browsers. It determines trusted sources of execution for dynamic
contents (JavaScript) or other web related assets: stylesheets, images, fonts, plugins, etc.

Web applications can send this header to mitigate Cross Site Scripting (XSS) attacks.

The default value allows images, scripts, AJAX, fonts and CSS from the same origin, and does not allow any
other resources to load (eg object, frame, media, etc).

Inline JavaScript is NOT allowed. To enable it, please use: <code>script-src 'unsafe-inline'</code>.

Example:

```ruby
security.content_security_policy %{
  form-action 'self';
  frame-ancestors 'self';
  base-uri 'self';
  default-src 'none';
  script-src 'self';
  connect-src 'self';
  img-src 'self' https: data:;
  style-src 'self' 'unsafe-inline' https:;
  font-src 'self';
  object-src 'none';
  plugin-types application/pdf;
  child-src 'self';
  frame-src 'self';
  media-src 'self'
}
```
