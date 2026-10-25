require_relative "test_helper"

require 'logger'
require 'stringio'
require 'tmpdir'

class LoggerLogDeviceSingletonTest < Test::Unit::TestCase
  include TestHelper

  library 'logger'
  testing "singleton(::Logger::LogDevice)"

  def test_new
    Dir.mktmpdir do |dir|
      path = File.join(dir, 't.log')
      assert_send_type  "(String) -> Logger::LogDevice",
                        Logger::LogDevice, :new, path
      assert_send_type  "(String, shift_age: Integer, shift_size: Integer) -> Logger::LogDevice",
                        Logger::LogDevice, :new, path, shift_age: 3, shift_size: 10485760
      assert_send_type  "(String, shift_age: String, shift_period_suffix: String) -> Logger::LogDevice",
                        Logger::LogDevice, :new, path, shift_age: 'daily', shift_period_suffix: '%Y-%m-%d'
      assert_send_type  "(String, binmode: bool, reraise_write_errors: Array[singleton(IOError)], skip_header: bool) -> Logger::LogDevice",
                        Logger::LogDevice, :new, path, binmode: true, reraise_write_errors: [IOError], skip_header: true
    end
    assert_send_type  "(StringIO) -> Logger::LogDevice",
                      Logger::LogDevice, :new, StringIO.new
  end
end

class LoggerLogDeviceTest < Test::Unit::TestCase
  include TestHelper

  library 'logger'
  testing "::Logger::LogDevice"

  def logdev
    Logger::LogDevice.new(StringIO.new)
  end

  def test_dev
    assert_send_type  "() -> StringIO",
                      logdev, :dev
  end

  def test_filename
    assert_send_type  "() -> String?",
                      logdev, :filename
  end

  def test_write
    assert_send_type  "(String) -> untyped",
                      logdev, :write, "My message\n"
  end

  def test_close
    assert_send_type  "() -> nil",
                      logdev, :close
  end

  def test_reopen
    assert_send_type  "() -> Logger::LogDevice",
                      logdev, :reopen
    assert_send_type  "(StringIO) -> Logger::LogDevice",
                      logdev, :reopen, StringIO.new
    Dir.mktmpdir do |dir|
      assert_send_type  "(String, shift_age: String, shift_size: nil, shift_period_suffix: String, binmode: bool) -> Logger::LogDevice",
                        logdev, :reopen, File.join(dir, 't.log'), shift_age: 'daily', shift_size: nil, shift_period_suffix: '%Y-%m-%d', binmode: true
    end
  end
end
