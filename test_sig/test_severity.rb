require_relative "test_helper"

require 'logger'

class LoggerSeverityTest < Test::Unit::TestCase
  include TestHelper

  library 'logger'
  testing "singleton(::Logger::Severity)"

  def test_constants
    assert_const_type "Integer", "Logger::Severity::DEBUG"
    assert_const_type "Integer", "Logger::Severity::INFO"
    assert_const_type "Integer", "Logger::Severity::WARN"
    assert_const_type "Integer", "Logger::Severity::ERROR"
    assert_const_type "Integer", "Logger::Severity::FATAL"
    assert_const_type "Integer", "Logger::Severity::UNKNOWN"
  end

end
