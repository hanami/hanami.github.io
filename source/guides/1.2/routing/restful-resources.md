---
title: Guides - RESTful Resource(s)
version: 1.2
---

# REST

Hanami has native [REST](http://en.wikipedia.org/wiki/Representational_state_transfer) support.

At the routing level, there are two methods that can be used to declare them: `resources` and `resource`.
The former is for plural resources, the latter for singular ones.

Declaring a resource means to generate **several default routes** with just one line of code.

## RESTful Resources

### Default Routes

```ruby
# apps/web/config/routes.rb
resources :books
```

It generates

<table class="table table-bordered table-striped">
  <tr>
    <th>Verb</th>
    <th>Path</th>
    <th>Action</th>
    <th>Name</th>
    <th>Named Route</th>
  </tr>
  <tr>
    <td>GET</td>
    <td>/books</td>
    <td>Books::Index</td>
    <td>:index</td>
    <td>:books</td>
  </tr>
  <tr>
    <td>GET</td>
    <td>/books/:id</td>
    <td>Books::Show</td>
    <td>:show</td>
    <td>:book</td>
  </tr>
  <tr>
    <td>GET</td>
    <td>/books/new</td>
    <td>Books::New</td>
    <td>:new</td>
    <td>:new_book</td>
  </tr>
  <tr>
    <td>POST</td>
    <td>/books</td>
    <td>Books::Create</td>
    <td>:create</td>
    <td>:books</td>
  </tr>
  <tr>
    <td>GET</td>
    <td>/books/:id/edit</td>
    <td>Books::Edit</td>
    <td>:edit</td>
    <td>:edit_book</td>
  </tr>
  <tr>
    <td>PATCH</td>
    <td>/books/:id</td>
    <td>Books::Update</td>
    <td>:update</td>
    <td>:book</td>
  </tr>
  <tr>
    <td>DELETE</td>
    <td>/books/:id</td>
    <td>Books::Destroy</td>
    <td>:destroy</td>
    <td>:book</td>
  </tr>
</table>

### Remove Routes

In case we don't need all the default routes we can use `:only` and pass one or more action names.
We can also black list routes with `:except`.

```ruby
resources :books, only: [:new, :create, :show]

# equivalent to

resources :books, except: [:index, :edit, :update, :destroy]
```

### Add Routes

Alongside with default routes we can specify extra routes for single (`member`) or multiple (`collection`) resources.

```ruby
resources :books do
  member do
    # Generates /books/1/toggle, maps to Books::Toggle, named :toggle_book
    get 'toggle'
  end

  collection do
    # Generates /books/search, maps to Books::Search, named :search_books
    get 'search'
  end
end
```

### Configure Controller

Imagine we have a controller named `manuscripts`, where we have actions like `Manuscripts::Index`, but we still want to expose those resources as `/books`.
Using the `:controller` option will save our day.

```ruby
resources :books, controller: 'manuscripts'

# GET /books/1 will route to Manuscripts::Show, etc.
```

## RESTful Resource

```ruby
resource :account
```

It generates

<table class="table table-bordered table-striped">
  <tr>
    <th>Verb</th>
    <th>Path</th>
    <th>Action</th>
    <th>Name</th>
    <th>Named Route</th>
  </tr>
  <tr>
    <td>GET</td>
    <td>/account</td>
    <td>Account::Show</td>
    <td>:show</td>
    <td>:account</td>
  </tr>
  <tr>
    <td>GET</td>
    <td>/account/new</td>
    <td>Account::New</td>
    <td>:new</td>
    <td>:new_account</td>
  </tr>
  <tr>
    <td>POST</td>
    <td>/account</td>
    <td>Account::Create</td>
    <td>:create</td>
    <td>:account</td>
  </tr>
  <tr>
    <td>GET</td>
    <td>/account/edit</td>
    <td>Account::Edit</td>
    <td>:edit</td>
    <td>:edit_account</td>
  </tr>
  <tr>
    <td>PATCH</td>
    <td>/account</td>
    <td>Account::Update</td>
    <td>:update</td>
    <td>:account</td>
  </tr>
  <tr>
    <td>DELETE</td>
    <td>/account</td>
    <td>Account::Destroy</td>
    <td>:destroy</td>
    <td>:account</td>
  </tr>
</table>

### Remove Routes

```ruby
resource :account, only: [:show, :edit, :update, :destroy]

# equivalent to

resource :account, except: [:new, :create]
```

### Add Routes

```ruby
resource :account do
  member do
    # Generates /account/avatar, maps to Account::Avatar, named :avatar_account
    get 'avatar'
  end

  collection do
    # Generates /account/authorizations, maps to Account::Authorizations, named :authorizations_account
    get 'authorizations'
  end
end
```

### Configure Controller

```ruby
resource :account, controller: 'customer'
```

## Nested Resource(s)

RESTful resource(s) can be nested in order to make available inner resources inside the scope of their parents.

### Plural to plural

```ruby
resources :books do
  resources :reviews
end
```

**It generates default routes for books and the following ones.**

<table class="table table-bordered table-striped">
  <tr>
    <th>Verb</th>
    <th>Path</th>
    <th>Action</th>
    <th>Name</th>
    <th>Named Route</th>
  </tr>
  <tr>
    <td>GET</td>
    <td>/books/:book_id/reviews</td>
    <td>Books::Reviews::Index</td>
    <td>:index</td>
    <td>:book_reviews</td>
  </tr>
  <tr>
    <td>GET</td>
    <td>/books/:book_id/reviews/:id</td>
    <td>Books::Reviews::Show</td>
    <td>:show</td>
    <td>:book_review</td>
  </tr>
  <tr>
    <td>GET</td>
    <td>/books/:book_id/reviews/new</td>
    <td>Books::Reviews::New</td>
    <td>:new</td>
    <td>:new_book_review</td>
  </tr>
  <tr>
    <td>POST</td>
    <td>/books/:book_id/reviews</td>
    <td>Books::Reviews::Create</td>
    <td>:create</td>
    <td>:book_reviews</td>
  </tr>
  <tr>
    <td>GET</td>
    <td>/books/:book_id/reviews/:id/edit</td>
    <td>Books::Reviews::Edit</td>
    <td>:edit</td>
    <td>:edit_book_review</td>
  </tr>
  <tr>
    <td>PATCH</td>
    <td>/books/:book_id/reviews/:id</td>
    <td>Books::Reviews::Update</td>
    <td>:update</td>
    <td>:book_review</td>
  </tr>
  <tr>
    <td>DELETE</td>
    <td>/books/:book_id/reviews/:id</td>
    <td>Books::Reviews::Destroy</td>
    <td>:destroy</td>
    <td>:book_review</td>
  </tr>
</table>

### Plural to singular

```ruby
resources :books do
  resource :cover
end
```

**It generates default routes for books and the following ones.**

<table class="table table-bordered table-striped">
  <tr>
    <th>Verb</th>
    <th>Path</th>
    <th>Action</th>
    <th>Name</th>
    <th>Named Route</th>
  </tr>
  <tr>
    <td>GET</td>
    <td>/books/:book_id/cover</td>
    <td>Books::Cover::Show</td>
    <td>:show</td>
    <td>:book_cover</td>
  </tr>
  <tr>
    <td>GET</td>
    <td>/books/:book_id/cover/new</td>
    <td>Books::Cover::New</td>
    <td>:new</td>
    <td>:new_book_cover</td>
  </tr>
  <tr>
    <td>POST</td>
    <td>/books/:book_id/cover</td>
    <td>Books::Cover::Create</td>
    <td>:create</td>
    <td>:book_cover</td>
  </tr>
  <tr>
    <td>GET</td>
    <td>/books/:book_id/cover/edit</td>
    <td>Books::Cover::Edit</td>
    <td>:edit</td>
    <td>:edit_book_cover</td>
  </tr>
  <tr>
    <td>PATCH</td>
    <td>/books/:book_id/cover</td>
    <td>Books::Cover::Update</td>
    <td>:update</td>
    <td>:book_cover</td>
  </tr>
  <tr>
    <td>DELETE</td>
    <td>/books/:book_id/cover</td>
    <td>Books::Cover::Destroy</td>
    <td>:destroy</td>
    <td>:book_cover</td>
  </tr>
</table>

### Singular To Plural

```ruby
resource :account do
  resources :api_keys
end
```

**It generates default routes for account and the following ones.**

<table class="table table-bordered table-striped">
  <tr>
    <th>Verb</th>
    <th>Path</th>
    <th>Action</th>
    <th>Name</th>
    <th>Named Route</th>
  </tr>
  <tr>
    <td>GET</td>
    <td>/account/api_keys</td>
    <td>Account::ApiKeys::Index</td>
    <td>:index</td>
    <td>:account_api_keys</td>
  </tr>
  <tr>
    <td>GET</td>
    <td>/account/api_keys/:id</td>
    <td>Account::ApiKeys::Show</td>
    <td>:show</td>
    <td>:account_api_key</td>
  </tr>
  <tr>
    <td>GET</td>
    <td>/account/api_keys/new</td>
    <td>Account::ApiKeys::New</td>
    <td>:new</td>
    <td>:new_account_api_key</td>
  </tr>
  <tr>
    <td>POST</td>
    <td>/account/api_keys</td>
    <td>Account::ApiKeys::Create</td>
    <td>:create</td>
    <td>:account_api_keys</td>
  </tr>
  <tr>
    <td>GET</td>
    <td>/account/api_keys/:id/edit</td>
    <td>Account::ApiKeys::Edit</td>
    <td>:edit</td>
    <td>:edit_account_api_key</td>
  </tr>
  <tr>
    <td>PATCH</td>
    <td>/account/api_keys/:id</td>
    <td>Account::ApiKeys::Update</td>
    <td>:update</td>
    <td>:account_api_key</td>
  </tr>
  <tr>
    <td>DELETE</td>
    <td>/account/api_keys/:id</td>
    <td>Account::ApiKeys::Destroy</td>
    <td>:destroy</td>
    <td>:account_api_key</td>
  </tr>
</table>

### Singular To Singular

```ruby
resource :account do
  resource :avatar
end
```

**It generates default routes for account and the following ones.**

<table class="table table-bordered table-striped">
  <tr>
    <th>Verb</th>
    <th>Path</th>
    <th>Action</th>
    <th>Name</th>
    <th>Named Route</th>
  </tr>
  <tr>
    <td>GET</td>
    <td>/account/avatar</td>
    <td>Account::Avatar::Show</td>
    <td>:show</td>
    <td>:account_avatar</td>
  </tr>
  <tr>
    <td>GET</td>
    <td>/account/avatar/new</td>
    <td>Account::Avatar::New</td>
    <td>:new</td>
    <td>:new_account_avatar</td>
  </tr>
  <tr>
    <td>POST</td>
    <td>/account/avatar</td>
    <td>Account::Avatar::Create</td>
    <td>:create</td>
    <td>:account_avatar</td>
  </tr>
  <tr>
    <td>GET</td>
    <td>/account/avatar/edit</td>
    <td>Account::Avatar::Edit</td>
    <td>:edit</td>
    <td>:edit_account_avatar</td>
  </tr>
  <tr>
    <td>PATCH</td>
    <td>/account/avatar</td>
    <td>Account::Avatar::Update</td>
    <td>:update</td>
    <td>:account_avatar</td>
  </tr>
  <tr>
    <td>DELETE</td>
    <td>/account/avatar</td>
    <td>Account::Avatar::Destroy</td>
    <td>:destroy</td>
    <td>:account_avatar</td>
  </tr>
</table>
