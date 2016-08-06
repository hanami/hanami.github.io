---
title: Guides - Custom Error Pages
---

# Custom Error Pages

When an unsuccessful request is returned, there are some special pages that a Hanami application presents to users.
These pages have a generic graphic and some basic information like the HTTP status code and the message.

Hanami allows us to customize them on a per-application basis.
We just need to create a template with the corresponding HTTP code as the filename (e.g. `apps/web/templates/500.html.erb`).
From then on, all the side errors will be presented using that template.

<p class="convention">
  A template for a custom error page MUST be named after the HTTP code that it targets.
  Example: <code>500.html.erb</code> for Internal Server Error (500).
</p>

<p class="convention">
  A template for a custom error page MUST be placed under the <code>templates</code> directory of the application.
</p>
