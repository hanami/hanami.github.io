---
title: "Guides - Entities: Data Types"
version: head
---

# Data Types

Data types are available for custom [entities schema](/guides/head/entities/custom-schema), which are *completely optional*.

We have 5 data types:

  * **Definition** - base type definition
  * **Strict** - strict type with primitive type check
  * **Coercible** - type with constructor that applies a coercion to given input
  * **Form** - type with constructor that applies a non-strict coercion, specific to HTTP params
  * **JSON** - type with constructor that applies a non-strict coercion, specific to JSON

## Definition

  * `Types::Nil`
  * `Types::String`
  * `Types::Symbol`
  * `Types::Int`
  * `Types::Float`
  * `Types::Decimal`
  * `Types::Class`
  * `Types::Bool`
  * `Types::True`
  * `Types::False`
  * `Types::Date`
  * `Types::DateTime`
  * `Types::Time`
  * `Types::Array`
  * `Types::Hash`

## Strict

  * `Types::Strict::Nil`
  * `Types::Strict::String`
  * `Types::Strict::Symbol`
  * `Types::Strict::Int`
  * `Types::Strict::Float`
  * `Types::Strict::Decimal`
  * `Types::Strict::Class`
  * `Types::Strict::Bool`
  * `Types::Strict::True`
  * `Types::Strict::False`
  * `Types::Strict::Date`
  * `Types::Strict::DateTime`
  * `Types::Strict::Time`
  * `Types::Strict::Array`
  * `Types::Strict::Hash`

## Coercible

  * `Types::Coercible::String`
  * `Types::Coercible::Int`
  * `Types::Coercible::Float`
  * `Types::Coercible::Decimal`
  * `Types::Coercible::Array`
  * `Types::Coercible::Hash`

## Form

  * `Types::Form::Nil`
  * `Types::Form::Int`
  * `Types::Form::Float`
  * `Types::Form::Decimal`
  * `Types::Form::Bool`
  * `Types::Form::True`
  * `Types::Form::False`
  * `Types::Form::Date`
  * `Types::Form::DateTime`
  * `Types::Form::Time`
  * `Types::Form::Array`
  * `Types::Form::Hash`

## JSON

  * `Types::Json::Nil`
  * `Types::Json::Decimal`
  * `Types::Json::Date`
  * `Types::Json::DateTime`
  * `Types::Json::Time`
  * `Types::Json::Array`
  * `Types::Json::Hash`

---

Hanami model data types are based on `dry-types` gem. Learn more at: [http://dry-rb.org/gems/dry-types](http://dry-rb.org/gems/dry-types)
