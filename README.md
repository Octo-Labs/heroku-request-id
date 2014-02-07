# HerokuRequestId

Simple Rack middleware to log the heroku request id and write it to the end of html requests. Both optionally, of course.

[![Gem Version](https://badge.fury.io/rb/heroku-request-id.png)](http://badge.fury.io/rb/heroku-request-id)


## Installation

Add this line to your application's Gemfile:

    gem 'heroku-request-id'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heroku-request-id

## Usage

By default the gem will print a log line to the Heroku logs
containing the request id and the elapsed time taken processing the
request.  You can disable the log line by putting this in an
initializer.

```ruby
  HerokuRequestId::Middleware.log_line = false
```

You can configure the gem to add a comment to the beginning of html
requests by adding this to an initializer.

```ruby
  HerokuRequestId::Middleware.html_comment = true
```

You can also configure the gem to copy the `HTTP_HEROKU_REQUEST_ID`
header, which is set by heroku, into the `HTTP_X_REQUEST_ID` header,
which is used by `ActionDispatch:: RequestId`.

```ruby
  HerokuRequestId::Middleware.x_request_id_replication = true
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
