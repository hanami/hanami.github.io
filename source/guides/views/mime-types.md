---
title: Lotus - Guides - MIME Types
---

# MIME Types

A view can handle several MIME Types. Before to dive into this subject, please consider to read how action handle [MIME Types](/guides/actions/mime-types).

It's important to highlight the correlation between the _format_ and template name.
For a given MIME Type, Rack (and then Lotus) associate a _format_ for it.
XML is mapped from `application/xml` to `:xml`, HTML is `text/html` and becomes `:html` for us.

<p class="convention">
Format MUST be the first extension of the template file name. Eg <code>dashboard/index.html.*</code>.
</p>

## Default Rendering

If our action (`Web::Controllers::Dashboard::Index`) is handling a JSON request, and we have defined a template for it (`apps/web/templates/dashboard/index.json.erb`), our view will use it for rendering.

```erb
# apps/web/templates/dashboard/index.json.erb
{"foo":"bar"}
```

```shell
% curl -H "Accept: application/json" http://localhost:2300/dashboard
{"foo":"bar"}
```

We're still able to request HTML format.

```erb
# apps/web/templates/dashboard/index.html.erb
<h1>Dashboard</h1>
```

```shell
% curl -H "Accept: text/html" http://localhost:2300/dashboard
<h1>Dashboard</h1>
```

In case we request an unsupported MIME Type, our application will raise an error.

```shell
% curl -H "Accept: application/xml" http://localhost:2300/dashboard
Lotus::View::MissingTemplateError: Can't find template "dashboard/index" for "xml" format.
```

## View For Specific Format

This scenario works well if the presentational logic of a view can be applied for all the format templates that it handles.
What if we want to have a [custom rendering](/guides/views/basic-usage) or different presentational logic?

We can inherit from our view and declare that our subclass only handle a specific format.

```ruby
# apps/web/views/dashboard/json_index.rb
require_relative './index'

module Web::Views::Dashboard
  class JsonIndex < Index
    format :json

    def render
      JSON.generate({foo: 'bar'})
    end
  end
end
```

JSON requests for `/dashboard`, will be handled by our `JsonIndex`.

<p class="notice">
There is NO convention between the handled format and the class name. The important part is <code>format :json</code>.
</p>

With the example above we took advantadge of custom rendering to not use the template and let our serializer to return JSON for us.
