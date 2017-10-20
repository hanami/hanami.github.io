---
title: "Guides - Command Line: Routes"
version: head
---

# Routes

In order to print the routes defined by all the applications, use:

```
% bundle exec hanami routes

                     GET, HEAD  /               Web::Controllers::Home::Index
               books GET, HEAD  /books          Web::Controllers::Books::Index
           new_books GET, HEAD  /books/new      Web::Controllers::Books::New
               books POST       /books          Web::Controllers::Books::Create
               books GET, HEAD  /books/:id      Web::Controllers::Books::Show
          edit_books GET, HEAD  /books/:id/edit Web::Controllers::Books::Edit
               books PATCH      /books/:id      Web::Controllers::Books::Update
               books DELETE     /books/:id      Web::Controllers::Books::Destroy
         new_account GET, HEAD  /account/new    Web::Controllers::Account::New
             account POST       /account        Web::Controllers::Account::Create
             account GET, HEAD  /account        Web::Controllers::Account::Show
        edit_account GET, HEAD  /account/edit   Web::Controllers::Account::Edit
             account PATCH      /account        Web::Controllers::Account::Update
             account DELETE     /account        Web::Controllers::Account::Destroy
```
