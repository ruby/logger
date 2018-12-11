# Logger

[![Build Status](https://travis-ci.com/ruby/logger.svg?branch=master)](https://travis-ci.com/ruby/logger.svg?branch=master)

Logger is a simple but powerful logging utility to output messages in your Ruby program.

Logger has the following features:

 * Print messages to different levels such as `info` and `error`
 * Auto-rolling of log files
 * Setting the format of log messages
 * Specifying a program name in conjunction with the message

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'logger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logger

## Usage

### Simple Example

    require 'logger'

    # Create a Logger that prints to STDOUT
    log = Logger.new(STDOUT)
    log.debug("Created Logger")

    log.info("Program finished")

    # Create a Logger that prints to STDERR
    error_log = Logger.new(STDERR)
    error_log = Logger.error("fatal error")

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ruby/logger.

## License

The gem is available as open source under the terms of the [BSD-2-Clause](LICENSE.txt).
