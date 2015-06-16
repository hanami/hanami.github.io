---
title: Lotus - Guides - Custom Error Pages
---

# Custom Error Pages

When a non successful request is returned, there are some special pages that an application presents to users.
They have a generic graphic and some basic informations like the HTTP status code and the message.

Lotus allow to customize them on an application basis.
We need to create a template with the corresponding HTTP code as filename (eg. `apps/web/templates/500.html.erb`).

Since now on, all the side errors will be presented using that template.

<p class="convention">
  A template for custom error page, MUST be named after the HTTP code that it targets.
  Example: <code>500.html.erb</code> for Internal Server Error (500).
</p>


<p class="convention">
  A template for custom error page, MUST be placed under the templates directory of the application.
</p>
