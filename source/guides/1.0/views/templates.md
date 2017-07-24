---
title: Guides - View Templates
version: 1.0
---

# Templates

A template is a file that describes the body of a response.
It is rendered by bounding the context of a view and using a _template engine_.

## Naming

For simplicity sake, there is a correlation between the view class name and the template file name.
It's the translation of the name into a path: from `Dashboard::Index` to `dashboard/index`.

The remaining part is made of multiple file extensions.
The first is relative to the **_format_** and the latter is for the **_template engine_**.

<p class="convention">
For a given view named <code>Web::Views::Dashboard::Index</code>, there must be at least one template <code>dashboard/index.[format].[engine]</code> under the templates directory.
</p>

## Nested Templates
To render a partial in other template call `render` method with `partial` option:

```
# Given a partial under:
#   templates/shared/_sidebar.html.erb
#
# In the layout template:
#   templates/application.html.erb
#
<%= render partial: 'shared/sidebar' %>
```

To render a template in other template call `render` method with `template` option:

```
# Given a template under:
#   templates/articles/index.html.erb
#
# In the layout template:
#   templates/application.html.erb
#
<%= render template: 'articles/index' %>
```

### Custom Template

If we want to associate a different template to a view, we can use `template`.

```ruby
# apps/web/views/dashboard/index.rb
module Web::Views::Dashboard
  class Index
    include Web::View
    template 'home/index'
  end
end
```

Our view will look for `apps/web/templates/home/index.*` template.

## Engines

Hanami looks at the last extension of a template file name to decide which engine to use (eg `index.html.erb` will use ERb).
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
# app/web/templates/dashboard/index.html.haml
%h1 Dashboard
```

## Directory

Templates are located in the default directory `templates`, located under an application's directory `apps/web`.
If we want to customize this location, we can amend our application's configuration.

```ruby
# apps/web/application.rb
module Web
  class Application < Hanami::Application
    configure do
      # ...
      templates 'path/to/templates'
    end
  end
end
```

The application will now look for templates under `apps/web/path/to/templates`.
