require_relative "test_helper"

require 'logger'

class LoggerFormatterTest < Test::Unit::TestCase
  include TestHelper

  library 'logger'
  testing "::Logger::Formatter"

  def test_call
    assert_send_type  "(String, Time, String, String) -> String",
                      Logger::Formatter.new, :call, 'INFO', Time.now, 'mung', 'My message'
    assert_send_type  "(String, Time, nil, RuntimeError) -> String",
                      Logger::Formatter.new, :call, 'ERROR', Time.now, nil, RuntimeError.new('No good')
  end

  def test_datetime_format
    assert_send_type  "() -> String?",
                      Logger::Formatter.new, :datetime_format
  end

  def test_datetime_format=
    assert_send_type  "(String) -> String",
                      Logger::Formatter.new, :datetime_format=, '%Y-%m-%d %H:%M:%S'
    assert_send_type  "(nil) -> nil",
                      Logger::Formatter.new, :datetime_format=, nil
  end
end
