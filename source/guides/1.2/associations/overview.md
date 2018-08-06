---
title: Guides - Associations Overview
version: 1.2
---

# Associations

An association is a logical relationship between two entities.

<p class="warning">
  As of the current version, Hanami supports associations as an experimental feature only for the SQL adapter.
</p>

## Design

Because the association is made of data linked together in a database, we define associations in repositories.

### Explicit Interface

When we declare an association, that repository **does NOT** get any extra method to its public interface.
This because Hanami wants to prevent to bloat in repositories by adding methods that are often never used.

<p class="notice">
  When we define an association, the repository doesn't get any extra public methods.
</p>

If we need to create an author, contextually with a few books, we need to explicitly define a method to perform that operation.

### Explicit Loading

The same principle applies to read operations: if we want to eager load an author with the associated books, we need an explicit method to do so.

If we don't explicitly load that books, then the resulting data will be `nil`.

### No Proxy Loader

Please remember that operations on associations are made via explicit repository methods.
Hanami **does NOT** support by design, the following use cases:

  * `author.books` (to try to load books from the database)
  * `author.books.where(on_sale: true)` (to try to load _on sale_ books from the database)
  * `author.books << book` (to try to associate a book to the author)
  * `author.books.clear` (to try to unassociate the books from the author)

Please remember that `author.books` is just an array, its mutation **won't be reflected in the database**.

## Types Of Associations

  * [Has Many](/guides/1.2/associations/has-many)
  * [Belongs To](/guides/1.2/associations/belongs-to)
  * [Has One](/guides/1.2/associations/has-one)
  * [Has Many Through](/guides/1.2/associations/has-many-through)
