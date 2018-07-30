---
title: Guides - View Testing
version: 1.3
---

# View Testing

One of the advantages of views as objects is that we can unit test them.
We can both understand if a specific presentational logic behaves correctly and/or assert the contents of the rendered markup.

For the following example we're gonna use RSpec for the concise syntax for test doubles.

```ruby
# spec/web/views/books/show_spec.rb
require 'spec_helper'
require_relative '../../../../apps/web/views/books/show'

RSpec.describe Web::Views::Books::Show do
  let(:exposures) { Hash[book: double('book', price: 1.00), current_user: user, params: {}] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/books/show.html.erb') }
  let(:view)      { Web::Views::Home::Another.new(template, exposures) }
  let(:rendered)  { view.render }
  let(:user)      { double('user', admin?: false) }

  describe "price" do
    it "returns formatted price" do
      expect(view.formatted_price).to eq "$1.00"
    end
  end

  describe "edit link" do
    it "doesn't show it by default" do
      expect(rendered).to_not match %(<a href="">edit</a>)
    end

    context "when admin" do
      let(:user) { double('user', admin?: true) }

      it "shows it" do
        expect(rendered).to match %(<a href="">edit</a>)
      end
    end
  end
end
```

The first part of the test code above is about book's formatting price.
This presentational logic is verified by asserting the returning value of `view.formatted_price`.

The remaining code is about permissions related logic: the edit link must be rendered only if the current user is an admin.
This is tested by looking at the output of the template.

<p class="notice">
  Asserting presentational logic directly via view's methods, or indirectly via rendered markup are two EQUIVALENT ways.
</p>

Notice that `exposures` includes an unused `params` key.
While this is not strictly required,
we recommend providing it since it's expected by some standard view helpers (e.g. form helpers).

Let's have a look at the corresponding production code.

```ruby
# apps/web/views/books/show.rb
module Web::Views::Books
  class Show
    include Web::View

    def formatted_price
      "$#{ format_number book.price }"
    end

    def edit_link
      if can_edit_book?
        link_to "Edit", routes.edit_book_path(id: book.id)
      end
    end

    private

    def can_edit_book?
      current_user.admin?
    end
  end
end
```
