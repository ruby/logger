require "test_helper"

class LoggerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Logger::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
