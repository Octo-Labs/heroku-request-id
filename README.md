# Heroku::Request::Id

TODO: Write a gem description

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
