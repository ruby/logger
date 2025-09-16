# coding: US-ASCII
# frozen_string_literal: false
require 'logger'

class TestFormatter < Test::Unit::TestCase
  def test_call
    severity = 'INFO'
    time = Time.now
    progname = 'ruby'
    msg = 'This is a test'
    formatter = Logger::Formatter.new
    time_matcher = /\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6}/

    result = formatter.call(severity, time, progname, msg)
    matcher = /#{severity[0..0]}, \[#{time_matcher} #\d+\]  #{severity} -- #{progname}: #{msg}\n/

    assert_match(matcher, result)
  end

  def test_call_with_context
    severity = 'INFO'
    time = Time.now
    progname = 'ruby'
    msg = 'This is a test'
    formatter = Logger::Formatter.new
    time_matcher = /\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6}/

    # context as hash
    result = formatter.call(severity, time, progname, msg, context: { foo: "bar" })
    matcher = /#{severity[0..0]}, \[foo=bar\] \[#{time_matcher} #\d+\]  #{severity} -- #{progname}: #{msg}\n/
    assert_match(matcher, result)

    # context as array
    result = formatter.call(severity, time, progname, msg, context: ["tag"])
    matcher = /#{severity[0..0]}, \[tag\] \[#{time_matcher} #\d+\]  #{severity} -- #{progname}: #{msg}\n/
    assert_match(matcher, result)

    # context as nil
    result = formatter.call(severity, time, progname, msg, context: nil)
    matcher = /#{severity[0..0]}, \[#{time_matcher} #\d+\]  #{severity} -- #{progname}: #{msg}\n/
    assert_match(matcher, result)

    # unsupported context
    assert_raise(Logger::Error) { formatter.call(severity, time, progname, msg, context: Object.new) }
  end

  class CustomFormatter < Logger::Formatter
    def call(time)
      format_datetime(time)
    end
  end

  def test_format_datetime
    time = Time.now
    formatter = CustomFormatter.new

    result = formatter.call(time)
    matcher = /^\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6}$/

    assert_match(matcher, result)
  end
end
