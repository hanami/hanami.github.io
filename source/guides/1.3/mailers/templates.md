---
title: Guides - View Templates
version: 1.2
---

# Templates

A template is a file that contains a body for a specific format of a multipart email.
For instance, `welcome.html.erb` describes the markup of the HTML part of the message, while `welcome.txt.erb` is for the textual part.

It is rendered by bounding the [context](/guides/1.2/mailers/basic-usage) of a mailer and using a _template engine_.

## Naming

For convenience, there is a correlation between the view mailer name and the template file name.
It's the translation of the name into a path: from `Mailers::ForgotPassword` to `forgot_password`.

The remaining part is made of multiple file extensions.
The first is relative to the **_format_** and the latter is for the **_template engine_**.

**Hanami only accepts `html` and `txt` formats for emails.**

<p class="convention">
For a given mailer named <code>Mailers::ForgotPassword</code>, there must be at least one template <code>forgot_password.[format].[engine]</code> under the mailers templates directory.
</p>

### Custom Template

If we want to associate a different template to a mailer, we can use `template`.

```ruby
# lib/bookshelf/mailers/forgot_password.rb
class Mailers::ForgotPassword
  include Hanami::Mailer
  template 'send_password'
end
```

Our view will look for `lib/bookshelf/mailers/templates/send_password.*` template.

## Engines

Hanami looks at the last extension of a template file name to decide which engine to use (eg `welcome.html.erb` will use ERb).
The builtin rendering engine is [ERb](http://en.wikipedia.org/wiki/ERuby), but Hanami supports countless rendering engines out of the box.

This is a list of the supported engines.
They are listed in order of **higher precedence**, for a given extension.
For instance, if [ERubis](http://www.kuwata-lab.com/erubis/) is loaded, it will be preferred over ERb to render `.erb` templates.

<table class="table table-bordered table-striped">
  <tr>
    <th>Engine</th>
    <th>Extensions</th>
  </tr>
  <tr>
    <td>Erubis</td>
    <td>erb, rhtml, erubis</td>
  </tr>
  <tr>
    <td>ERb</td>
    <td>erb, rhtml</td>
  </tr>
  <tr>
    <td>Redcarpet</td>
    <td>markdown, mkd, md</td>
  </tr>
  <tr>
    <td>RDiscount</td>
    <td>markdown, mkd, md</td>
  </tr>
  <tr>
    <td>Kramdown</td>
    <td>markdown, mkd, md</td>
  </tr>
  <tr>
    <td>Maruku</td>
    <td>markdown, mkd, md</td>
  </tr>
  <tr>
    <td>BlueCloth</td>
    <td>markdown, mkd, md</td>
  </tr>
  <tr>
    <td>Asciidoctor</td>
    <td>ad, adoc, asciidoc</td>
  </tr>
  <tr>
    <td>Builder</td>
    <td>builder</td>
  </tr>
  <tr>
    <td>CSV</td>
    <td>rcsv</td>
  </tr>
  <tr>
    <td>CoffeeScript</td>
    <td>coffee</td>
  </tr>
  <tr>
    <td>WikiCloth</td>
    <td>wiki, mediawiki, mw</td>
  </tr>
  <tr>
    <td>Creole</td>
    <td>wiki, creole</td>
  </tr>
  <tr>
    <td>Etanni</td>
    <td>etn, etanni</td>
  </tr>
  <tr>
    <td>Haml</td>
    <td>haml</td>
  </tr>
  <tr>
    <td>Less</td>
    <td>less</td>
  </tr>
  <tr>
    <td>Liquid</td>
    <td>liquid</td>
  </tr>
  <tr>
    <td>Markaby</td>
    <td>mab</td>
  </tr>
  <tr>
    <td>Nokogiri</td>
    <td>nokogiri</td>
  </tr>
  <tr>
    <td>Plain</td>
    <td>html</td>
  </tr>
  <tr>
    <td>RDoc</td>
    <td>rdoc</td>
  </tr>
  <tr>
    <td>Radius</td>
    <td>radius</td>
  </tr>
  <tr>
    <td>RedCloth</td>
    <td>textile</td>
  </tr>
  <tr>
    <td>Sass</td>
    <td>sass</td>
  </tr>
  <tr>
    <td>Scss</td>
    <td>scss</td>
  </tr>
  <tr>
    <td>Slim</td>
    <td>slim</td>
  </tr>
  <tr>
    <td>String</td>
    <td>str</td>
  </tr>
  <tr>
    <td>Yajl</td>
    <td>yajl</td>
  </tr>
</table>

In order to use a different template engine we need to bundle the gem and to use the right file extension.

```haml
# lib/bookshelf/mailers/templates/welcome.html.haml
%h1 Welcome
```

## Templates Directory

Templates are located in the default directory `mailers/templates`, located under an application's directory `lib/bookshelf`, where `bookshelf` is the name of our application.
If we want to customize this location, we can set a different value in Hanami::Mailer configuration.

```ruby
# lib/bookshelf.rb
# ...

Hanami::Mailer.configure do
  # ...
  root 'path/to/templates'
end.load!
```

The application will now look for templates under `path/to/templates`.
