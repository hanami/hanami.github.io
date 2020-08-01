---
title: Security
---

# Security

## Features

We believe in a secure web, made by secure applications.

We offer advanced security features to protect against common attacks.
Hanami implements synchronized tokens against Cross-Site Request Forgery (CSRF), automatic HTML escaping to prevent Cross-site Scripting (XSS), a clear database API to avoid SQL Injection, Content-Security-Policy to stop untrusted assets to be loaded by you customer's browser, and other features.

We actively ship security improvements and assess for new vulnerabilities.

## Reporting a vulnerability

If you find a vulnerability, please be responsible and do not share it publicly. Instead, please contact us:

  1. Email to [admin@hanamirb.org](mailto:admin@hanamirb.org), you should receive a reply within 24 hours
  2. If you don't get an answer, please contact privately [Luca Guidi](mailto:me@lucaguidi.com) or another member of the [core team](/team)
  3. If none of those worked, please announce on the [chat](http://chat.hanamirb.org) that you have a security problem to report. Please do **NOT** share the problem in chat, as it's a public channel

## Disclosure policy

Once we'll have received the security report, we'll proceed like this:

  1. Once the security report is received, we'll assign it to a primary contact. This person is responsible for the entire process
  2. When the problem is confirmed, we'll determine the supported versions affected and audit the code to find similar vulnerabilities
  3. We'll write patches, but not share them over our [GitHub organization](https://github.com/hanami) until the end of the process
  4. We'll contact the vulnerability reporter again, to double-check that the patches fix the problem
  5. We'll obtain a CVE from MITRE
  6. We'll apply the patches to our codebase over GitHub, release the gems over Rubygems, and write a public announcement.

We'll try our best to handle the process in a timely manner, please be patient.
We are dedicated to building and maintaining a secure framework, but we're all volunteers.

## Anatomy of an announcement

The security announcement will contain:

  * A detailed description of the problem
  * The CVE ID (if present)
  * The steps that we'll take to prevent similar problems
  * The affected/non-affected versions
  * The released versions
  * The patches as downloadable files

## Supported versions

We currently support the `1.x` series of Hanami.
