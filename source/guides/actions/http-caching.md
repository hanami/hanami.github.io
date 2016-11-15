---
title: Guides - Action HTTP Caching
---

# HTTP Caching

We refer to HTTP caching as the set of techniques for HTTP 1.1 and implemented by browser vendors in order to make faster interactions with the server.
There are a few headers that, if sent, will enable these HTTP caching mechanisms.

## Cache Control

Actions offer a DSL to set a special header `Cache-Control`.
The first argument is a cache response directive like `:public` or `"must-revalidate"`, while the second argument is a set of options like `:max_age`.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action

    cache_control :public, max_age: 600
      # => Cache-Control: public, max-age: 600

    def call(params)
      # ...
    end
  end
end
```

## Expires

Another HTTP caching special header is `Expires`.
It can be used for retrocompatibility with old browsers which don't understand `Cache-Control`.

Hanami's solution for _expire_ combines support for all the browsers by sending both the headers.

```ruby
# apps/web/controllers/dashboard/index.rb
module Web::Controllers::Dashboard
  class Index
    include Web::Action
    expires 60, :public, max_age: 300
      # => Expires: Mon, 18 May 2015 09:19:18 GMT
      #    Cache-Control: public, max-age: 300

    def call(params)
      # ...
    end
  end
end
```

## Conditional GET

_Conditional GET_ is a two step workflow to inform browsers that a resource hasn't changed since the last visit.
At the end of the first request, the response includes special HTTP response headers that the browser will use next time it comes back.
If the header matches the value that the server calculates, then the resource is still cached and a `304` status (Not Modified) is returned.

### ETag

The first way to match a resource freshness is to use an identifier (usually an MD5 token).
Let's specify it with `fresh etag:`.

If the given identifier does NOT match the `If-None-Match` request header, the request will return a `200` with an `ETag` response header with that value.
If the header does match, the action will be halted and a `304` will be returned.

```ruby
# apps/web/controllers/users/show.rb
module Web::Controllers::Users
  class Show
    include Web::Action

    def call(params)
      @user = UserRepository.new.find(params[:id])
      fresh etag: etag

      # ...
    end

    private

    def etag
      "#{ @user.id }-#{ @user.updated_at }"
    end
  end
end

# Case 1 (missing or non-matching If-None-Match)
# GET /users/23
#  => 200, ETag: 84e037c89f8d55442366c4492baddeae

# Case 2 (matching If-None-Match)
# GET /users/23, If-None-Match: 84e037c89f8d55442366c4492baddeae
#  => 304
```

### Last Modified

The second way is to use a timestamp via `fresh last_modified:`.

If the given timestamp does NOT match `If-Modified-Since` request header, it will return a `200` and set the `Last-Modified` response header with the timestamp value.
If the timestamp does match, the action will be halted and a `304` will be returned.

```ruby
# apps/web/controllers/users/show.rb
module Web::Controllers::Users
  class Show
    include Web::Action

    def call(params)
      @user = UserRepository.new.find(params[:id])
      fresh last_modified: @user.updated_at

      # ...
    end
  end
end

# Case 1 (missing or non-matching Last-Modified)
# GET /users/23
#  => 200, Last-Modified: Mon, 18 May 2015 10:04:30 GMT

# Case 2 (matching Last-Modified)
# GET /users/23, If-Modified-Since: Mon, 18 May 2015 10:04:30 GMT
#  => 304
```
