---
title: Guides - Use Your Own Assets Management
version: head
---

# Use Your Own Assets Management

Hanami tries to cover basic use cases for assets management: [(pre)compilation](/guides/head/assets/overview/#compile-mode), [compression](/guides/head/assets/compressors), [fingerprinting](/guides/head/assets/overview/#fingerprint-mode), [Content Delivery Network (CDN)](/guides/head/assets/content-delivery-network) with [Subresource Integrity](/guides/head/assets/content-delivery-network/#subresource-integrity).

If it still doesn't fit your needs, you can use your own assets management tool such as Webpack.

## Deployment

To do so, please organize the assets according to your assets management tool and **don't** run `bundle exec hanami assets precompile` when deploying your project, but follow the instructions of your assets management software.

Please remember that for compatibility with the [Ruby server hosting ecosystem](/guides/head/projects/rake/#ruby-server-hosting-ecosystem-compatibility), we make available a special Rake task `assets:precompile`, which is run automatically by SaaS vendors.
If this is your situation, you may want override this task in the `Rakefile` of your project, with something more useful for you.
