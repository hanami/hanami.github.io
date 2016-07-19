---
title: Hanami | Guides - Form Helpers
---

## Form Helpers

It provides a powerful Ruby API to describe HTML5 forms, to be used both with views and templates. It ships with:

   * Support for complex markup without the need of concatenation
   * Auto closing HTML5 tags
   * Support for view local variables
   * Method override support (`PUT`/`PATCH`/`DELETE` HTTP verbs aren't understood by browsers)
   * Automatic generation of HTML attributes for inputs: `id`, `name`, `value`
   * Allow to override automatic HTML attributes
   * Read values from request params and/or given entities, to autofill `value` attributes
   * Automatic selection of current value for radio button and select inputs
   * CSRF Protection
   * Infinite nested fields
   * ORM Agnostic

## Technical notes

### Zero monkey-patching

This feature has a similar syntax to other Ruby gems with the same purpose, but it has a different usage if compared with Rails or Padrino.

Those frameworks allow a syntax like this:

```erb
<%= form_for :book do |f| %>
  <div>
    <%= f.text_field :title %>
  </div>
<% end %>
```

The code above **isn't a valid ERB template**. To make it work, Rails uses monkey-patches ERB, and Padrino supports only HAML with that syntax.

One of the pillars of Hanami is _"zero monkey-patch of Ruby core and stdlib"_. We want to keep this principle for this feature too.

### Template engine independent

Avoiding monkey-patching has a big advantage: **form helpers are designed to be independent from the template engine**. That means we can use Slim, HAML, or ERB and keep the same Ruby syntax.

### One output block

The technical compromise for the principles described above is to use the form builder in an unique output block.

```erb
<%=
  form_for :book, routes.books_path do
    text_field :title

    submit 'Create'
  end
%>
```

This will produce

```html
<form action="/books" id="book-form" method="POST">
  <input type="hidden" name="_csrf_token" value="0a800d6a8fc3c24e7eca319186beb287689a91c2a719f1cbb411f721cacd79d4">
  <input type="text" name="book[title]" id="book-id" value="">
  <button type="submit">Create</button>
</form>
```

### Method in views

An **alternative usage** is to define a concrete method in a view and to use it in the template:

```ruby
module Web::Views::Books
  class New
    include Web::View

    def form
      form_for :book, routes.books_path do
        text_field :title

        submit 'Create'
      end
    end
  end
end
```

```erb
<%= form %>
```

### Supported methods

* color_field
* datalist
* date_field
* datetime_field
* datetime_local_field
* email_field
* fields_for
* file_field
* form_for
* hidden_field
* label
* password_field
* radio_button
* select
* submit
* text_area
* text_field

## Examples

### Basic usage

The API is really clean and concise, **it doesn't require concatenation** between the returning value of the block (`submit`) and the previous lines (`div`).

```erb
<%=
  form_for :book, routes.books_path, class: 'form-horizontal' do
    div do
      label      :title
      text_field :title, class: 'form-control'
    end

    submit 'Create'
  end
%>
```

```html
<form action="/books" id="book-form" method="POST" class="form-horizontal">
  <input type="hidden" name="_csrf_token" value="1825a0a7ea92bbe3fd60cc8b6a0ea00ce3c52030afbf4037370d937bc5248acb">
  <div>
    <label for="book-title">Title</label>
    <input type="text" name="book[title]" id="book-title" value="Test Driven Development" class="form-control">
  </div>

  <button type="submit">Create</button>
</form>
```

### Method override

Browsers don't understand HTTP methods outside of `GET` and `POST`. On the other hand, Hanami embraces REST conventions, that goes beyond that two verbs. When we specify a method via `:method`, it adds a special hidden field `_method`, that's understood by the application.

```erb
<%=
  form_for :book, routes.book_path(book.id), method: :put do
    text_field :title

    submit 'Update'
  end
%>
```

```html
<form action="/books/23" id="book-form" method="POST">
  <input type="hidden" name="_method" value="PUT">
  <input type="hidden" name="_csrf_token" value="5f1029dd15981648a0882ec52028208410afeaeffbca8f88975ef199e2988ce7">
  <input type="text" name="book[title]" id="book-title" value="Test Driven Development">

  <button type="submit">Update</button>
</form>
```

### CSRF Protection

Cross Site Request Forgery (CSRF) is one of the most common attacks on the web. Hanami offers a security mechanism based on a technique called: _Synchronizer Token Pattern_.

When we enable sessions, it uses them to store a random token for each user.
Forms are rendered with a special hidden field (`_csrf_token`) which contains this token.

On form submission, Hanami matches this input with the value from the session. If they match, the request can continue. If not, it resets the sesssion and raises an exception.

Developers can customize attack handling.

### Nested fields

```erb
<%=
  form_for :delivery, routes.deliveries_path do
    text_field :customer_name

    fields_for :address do
      text_field :city
    end

    submit 'Create'
  end
%>
```

```html
<form action="/deliveries" id="delivery-form" method="POST">
  <input type="hidden" name="_csrf_token" value="4800d585b3a802682ae92cb72eed1cdd2894da106fb4e9e25f8a262b862c52ce">
  <input type="text" name="delivery[customer_name]" id="delivery-customer-name" value="">
  <input type="text" name="delivery[address][city]" id="delivery-address-city" value="">

  <button type="submit">Create</button>
</form>
```

## Automatic values

Form fields are **automatically filled with the right value**. Hanami looks up for explicit values passed in the form constructor and for the params of the current request. It compares the form hierarchy (including nested fields), with these two sources. For each match, it fills the associated value.

#### Example

Imagine we want to update data for `delivery`. We have two objects: `delivery` and `customer`, which are plain objects (no ORM involved). They respond to the following methods:

```ruby
delivery.id   # => 1
delivery.code # => 123

customer.name # => "Luca"

customer.address.class # => Address
customer.address.city  # => "Rome"
```

Let's compose the form.

```erb
<%=
  form_for :delivery, routes.delivery_path(id: delivery.id), method: :patch, values: {delivery: delivery, customer: customer} do
    text_field :code

    fields_for :customer do
      text_field :name

      fields_for :address do
        text_field :city
      end
    end

    submit 'Update'
  end
%>
```

```html
<form action="/deliveries/1" id="delivery-form" method="POST">
  <input type="hidden" name="_method" value="PATCH">
  <input type="hidden" name="_csrf_token" value="4800d585b3a802682ae92cb72eed1cdd2894da106fb4e9e25f8a262b862c52ce">

  <input type="text" name="delivery[code]" id="delivery-code" value="123">

  <input type="text" name="delivery[customer][name]" id="delivery-customer-name" value="Luca">
  <input type="text" name="delivery[customer][address][city]" id="delivery-customer-address-city" value="Rome">

  <button type="submit">Update</button>
</form>
```

Please note the `:values` option that we pass to `#form_for`. It maps the `name` attributes that we have in the form with the objects that we want to use to fill the values. For instance `delivery[code]` corresponds to `delivery.code` (`123`), `delivery[customer][address][city]` to `customer.address.city` (`"Rome"`) and so on..

### Read Values From Params

**Params are automatically passed to form helpers**, to read values and try to autofill fields. If a value is present both in params and explicit values (`:values`), the first takes precendence. The reason is simple: params sometimes represent a failed form submission attempt.

#### Example

Imagine the form described above, and that our user enters `"foo"` as delivery code. This value isn't acceptable for our model domain rules, so we render again the form, presenting a validation error. Our params are now carrying on the values filled by our user. For instance: `params.get('delivery.code')` returns `"foo"`.

Here how the form is rendered:

```html
<form action="/deliveries/1" id="delivery-form" method="POST">
  <input type="hidden" name="_method" value="PATCH">
  <input type="hidden" name="_csrf_token" value="4800d585b3a802682ae92cb72eed1cdd2894da106fb4e9e25f8a262b862c52ce">

  <input type="text" name="delivery[code]" id="delivery-code" value="foo">

  <input type="text" name="delivery[customer][name]" id="delivery-customer-name" value="Luca">
  <input type="text" name="delivery[customer][address][city]" id="delivery-customer-address-city" value="Rome">

  <button type="submit">Update</button>
</form>
```
