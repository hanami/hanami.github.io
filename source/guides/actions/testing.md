---
title: Lotus - Guides - Action Testing
---

# Testing

Lotus pays a lot of attention to code testability and it offers advanced features to make our lives easier.
The framework supports Minitest (default) and RSpec.

## Unit Tests

First of all, actions can be unit tested.
That means we can instantiate, excercise and verify expectations **directly on actions instances**.

```ruby
# spec/web/controllers/dashboard/index_spec.rb
require 'spec_helper'
require_relative '../../../../apps/web/controllers/dashboard/index'

describe Web::Controllers::Dashboard::Index do
  let(:action) { Web::Controllers::Dashboard::Index.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end
end
```

In the example above, `action` is an instance of `Web::Controllers::Dashboard::Index`, we can invoke `#call` on it, passing a Hash of parameters.
The [implicit returning value](/guides/actions/rack-integration) is a serialized Rack response.
We're asserting that the status code (`response[0]`) is successful (equals to `200`).

### Running Tests

We can run the entire test suite or a single file.

The default Rake task for the application serves for our first case: `bundle exec rake`.
All the dependencies and the application code (actions, views, entities, etc..) are eagerly loaded.
**Boot time is slow in this case.**

<p class="notice">
The entire test suite can be run via default Rake task. It loads all the dependencies, and the application code.
</p>

The second scenario can be done via: `ruby -Ispec spec/web/controllers/dashboard/index_spec.rb` (or `rspec spec/web/controllers/dashboard/index_spec.rb` if we use RSpec).
When we run a single file example **only the framework and the application settings are loaded**.

Please note the `require_relative` line in the example.
It's **auto generated for us** and it's needed to load the current action under test.
This mechanism allows us to run unit tests in **isolation**.
**Boot time is magnitudes faster**.

<p class="notice">
A single unit test can be run directly. It only loads the dependencies, but not the application code.
The class under test is loaded via <code>require_relative</code>, a line automatically generated for us.
In this way we can have a faster startup time and a shorter feedback cycle.
</p>

### Params

When testing an action, we can easily simulate parameters and headers coming from the request.
We just need to pass them as a Hash.
Headers for Rack env such as `HTTP_ACCEPT` can be mixed with params like `:id`.

The following test example uses both.

```ruby
# spec/web/controllers/users/show_spec.rb
require 'spec_helper'
require_relative '../../../../apps/web/controllers/users/show'

describe Web::Controllers::Users::Show do
  let(:action)  { Web::Controllers::Users::Show.new }
  let(:format)  { 'application/json' }
  let(:user_id) { '23' }

  it "is successful" do
    response = action.call(id: user_id, 'HTTP_ACCEPT' => format)

    response[0].must_equal                 200
    response[1]['Content-Type'].must_equal "#{ format }; charset=utf-8"
    response[2].must_equal                 ["ID: #{ user_id }"]
  end
end
```

Here the corresponding production code.

```ruby
# apps/web/controllers/users/show.rb
module Web::Controllers::Users
  class Show
    include Web::Action

    def call(params)
      puts params.class # => Web::Controllers::Users::Show::Params
      self.body = "ID: #{ params[:id] }"
    end
  end
end
```

<p class="notice">
Simulating request params and headers is simple for Lotus actions. We pass them as a <code>Hash</code> and they are transformed into an instance of <code>Lotus::Action::Params</code>.
</p>

### Exposures

There are cases where we want to verify the internal state of an action.
Imagine we have a classic user profile page, like depicted in the example above.
The action asks for a record that corresponds to the given id, and then set a `@user` instance variable.
How do we verify that the record is the one that we are looking for?

Because we want to make `@user` available to the outside world, we're going to use an [_exposure_](/guides/actions/exposures).
They are used to pass a data payload between an action and the corresponding view.
When we do `expose :user`, Lotus creates a getter (`#user`), so we can easily assert if the record is the right one.

```ruby
# apps/web/controllers/users/show.rb
module Web::Controllers::Users
  class Show
    include Web::Action
    expose :user, :foo

    def call(params)
      @user = UserRepository.find(params[:id])
      @foo  = 'bar'
    end
  end
end
```

We have used two _exposures_: `:user` and `:foo`, let's verify if they are properly set.

```ruby
# spec/web/controllers/users/show_spec.rb
require 'spec_helper'
require_relative '../../../../apps/web/controllers/users/show'

describe Web::Controllers::Users::Show do
  before do
    @user = UserRepository.create(User.new(name: 'Luca'))
  end

  let(:action)  { Web::Controllers::Users::Show.new }

  it "is successful" do
    response = action.call(id: @user.id)

    response[0].must_equal 200

    action.user.must_equal @user
    action.exposures.must_equal({user: @user, foo: 'bar'})
  end
end
```

<p class="notice">
The internal state of an action can be easily verified with <em>exposures</em>.
</p>

### Dependency Injection

During unit testing, we may want to use mocks to make tests faster or to avoid hitting external systems like databases, file system or remote services.
Because we can instantiate actions during tests, there is no need to use testing antipatterns (eg. `any_instance_of`, or `UserRepository.stub(:find)`).
Instead, we can just specify which collaborators we want to use via _dependency injection_.

Let's rewrite the test above so that it does not hit the database.
We're going to use RSpec for this example as it has a nicer API for mocks (doubles).

```ruby
# spec/web/controllers/users/show_spec.rb
require 'spec_helper'
require_relative '../../../../apps/web/controllers/users/show'

RSpec.describe Web::Controllers::Users::Show do
  let(:action)     { Web::Controllers::Users::Show.new(repository: repository) }
  let(:user)       { User.new(id: 23, name: 'Luca') }
  let(:repository) { double('repository', find: user) }

  it "is successful" do
    response = action.call(id: user.id)

    expect(response[0]).to      eq 200
    expect(action.user).to      eq user
    expect(action.exposures).to eq({user: user})
  end
end
```

We have injected the repository dependency which is a mock in our case.
Here how to adapt our action.

```ruby
# apps/web/controllers/users/show.rb
module Web::Controllers::Users
  class Show
    include Web::Action
    expose :user

    def initialize(repository: UserRepository)
      @repository = repository
    end

    def call(params)
      @user = @repository.find(params[:id])
    end
  end
end
```

<p class="warning">
Please be careful using doubles in unit tests. Always verify that the mocks are in a true representation of the corresponding production code.
</p>

## Requests Tests

Unit tests are a great tool to assert that low level interfaces works as expected.
We always advise combining them with integration tests.

In the case of Lotus web applications, we can write features (aka acceptance tests) with Capybara, but what do we use when we are building HTTP APIs?
The tool that we suggest is `rack-test`.

Imagine we have an API application mounted at `/api/v1` in our `Lotus::Container`.

```ruby
# config/environment.rb
# ...
Lotus::Container.configure do
  mount ApiV1::Application, at: '/api/v1'
  mount Web::Application,   at: '/'
end
```

Then we have the following action.

```ruby
# apps/api_v1/controllers/users/show.rb
module ApiV1::Controllers::Users
  class Show
    include ApiV1::Action
    accept :json

    def call(params)
      user = UserRepository.find(params[:id])
      self.body = JSON.generate(user.to_h)
    end
  end
end
```

In this case we don't care too much about the internal state of the action, but about the output visible to the external world.
This is why we haven't set `user` as an instance variable and why we haven't exposed it.

```ruby
# spec/api_v1/requests/users_spec.rb
require 'spec_helper'

describe "API V1 users" do
  include Rack::Test::Methods

  before do
    @user = UserRepository.create(User.new(name: 'Luca'))
  end

  # app is required by Rack::Test
  def app
    Lotus::Container.new
  end

  it "is successful" do
    get "/api/v1/users/#{ @user.id }"

    last_response.must_be :ok?
    last_response.body.must_equal(JSON.generate(@user.to_h))
  end
end
```

<p class="notice">
Please avoid doubles when writing full integration tests, as we want to verify that the whole stack is behaving as expected.
</p>
