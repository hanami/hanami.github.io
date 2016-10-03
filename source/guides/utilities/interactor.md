#### What is an Interactor?

`Interactor` is an extremely powerful module as part of `Hanami::Utils`. Let's look at some basics, a practical example and then see what makes the `Interactor` so useful and powerful.

`Hanami::Interactor` is a take on a Service Object pattern. In short, in will encapsulate functionality for us.

#### Overview
`Hanami::Interactor` is a "wrapper" for functionality - it provides generic, automatic tools for interacting with it, hence the name.

Because it's just a module, it can be `include`d in a class. It will give you access to the following methods and functionality:

* `Interactor` class will call `self.valid?` after initialization unless `self.valid?` returns `true`. 
> Note that `self.valid?` must return `true` or `false` - "truthy" or "falsy" returns will result in a failed status!
2. In order to use the `Interactor`, the host class must have the following methods present: `.initialize()`, `.call()` and an (optional) private method `.valid?()`.
3. `error()` method is provided to catalogue errors (this does not stop code execution, but results in a failed interaction). Accepts a string.
4. `error!()` method keeps the first error string provided, fails the interaction and like `error()`, doesn't prevent the code from working.
6. `fail!()` is like `error!()`, except it halts further code execution.

Last but not least, the result of a `.call()` method is a `Hanami::Interactor::Result` object. You can call `.success?` on it to see the result of the interaction (which will return a `Boolean`) or you can see accumulated errors array by calling `.errors`. 

Lastly, if any session variable has been `expose`d in the class, `Hanami::Interactor::Result` will expose it as well.

#### The Example

Let's say someone is abusing our Bookshelf program by submitting books using automated tools, resulting in thousands of bunk titles. We implement a ReCaptcha class to stop them.

There is a lot to go through, but don't be discouraged as you look, and we'll make sense of it:

```ruby
require 'hanami/interactor'
require 'httparty'

class ReCaptcha
  include Hanami::Interactor
  expose :remote_ip

  def initialize(**params)
    @params = params
  end

  def call
    error("Fatal: ENV['RECAPTCHA_SECRET'] is not set!") unless ENV['RECAPTCHA_SECRET']
    error("Fatal: ENV['RECAPTCHA_URL'] is not set!")    unless ENV['RECAPTCHA_URL']

    recaptcha_data  = @params[:recaptcha_token]
    remote_ip       = @params[:remote_ip]
    post_body       = build_POST_body

    response = HTTParty.post(URI.parse(ENV['RECAPTCHA_URL']), { body: post_body })

    unless response['success']
      error('ReCaptcha check returned `false`. This happens if someone tried to submit the form anyway.')
      error(response['ReCaptchaErrors']) if response['error-codes']
    end
  end

  def valid?
    result = Params.call(@params)
    result.success?
  end

  # Dry::Validation.Schema returns and thus defines a 
  # class inside of ReCaptcha class.
  # Read more about how this works: https://github.com/dry-rb/dry-validation
  Params = Dry::Validation.Schema do
    required(:recaptcha_token) { filled? & type?(String) }
    required(:remote_ip)       { filled? & type?(String) }
  end

  private
  def build_POST_body
    "secret=#{ENV['RECAPTCHA_SECRET']}&remote_ip=#{@params[:remote_ip]}&response=#{@params[:recaptcha_token]}"
  end
end
```

That's quite a bit of code so let's look at it more closely. 

First, we're using an excellent [HTTParty](https://github.com/jnunemaker/httparty) gem to make POSTing to ReCaptcha a breeze. This gem is not required.

Let's look at what happens when one calls `ReCaptcha.new(recaptcha_token: token, remote_ip: ip).call()`:

Assuming the initial input is correct:

1. The initialization occurs and `@params` variable is created.
2. Immediately after, `valid?` is executed.
3. If the fields (as per the `Dry::Validation::Schema`) are _empty_ or are _not of type `String`_, the return value will be `false`. Interaction stops and the result object's `.success?` method returns `false`. In this case, let's assume the result is `true`.
4. Because `.valid?` returned `true`, `.call()` is executed.
5. ReCaptcha-specific code is executed. Note that any errors collected here will cause the Interaction to fail and are kept for debugging purposes. `error()` methods are completely optional. (So is `.valid?`, actually)
6. `.call()` is completed and the resulting `Hanami::Interactor::Result` object responds to `.success?` with `true`.

> Please note that any Exceptions throw inside of `.call()` **will be quietly caught for you**, unless `rescue`d them specifically! This could be useful to add another `error()` or more than likely a `fail!()`.

Finally, let's look at how this interactor is useful inside our `apps/web/controllers/home/submit.rb` action:

```ruby
module Web::Controllers::Home
  class Submit
    include Web::Action

    def call(params)
      result = ReCaptcha.new(
        recaptcha_data: params[:'g-recaptcha-response'], 
        remote_ip: ENV['HTTP_X_FORWARDED_FOR']
      ).call()
      if result.success?
        redirect_to routes.captcha_passed
      else
        redirect_to routes.captcha_failed
      end
    end
  end
end
```

As you can see, our Controller is nice and clean with all of the logic easily testable in the `Interactor`, which will not break our application because all we can expect from `result` is a `Boolean` value.

The `Interactor` now:
* Cleans up the Action to a series of yes/no gates making our app less likely to blow up with an uncaught exception.
* Makes testing easier as each `Interactor` can be tested on its own.
* Compartmentalizes code so that the code can be re-used later instead of being a part of, and dependent on, a framework.
* Provides a set of tools to monitor (with `error()`s) or stop (`fail!()`) busy logic that has no place in the controller/action.

When used properly, the `Interactor` eases the pain of testing, cleans up your controllers, compartmentalizes your code and, in general, keeps with the credo that we should avoid errors earlier - in the params - rather than later, in the business logic. If we do encounter them - we'd rather see which feature failed rather than which controller failed.
