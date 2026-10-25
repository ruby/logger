require_relative "test_helper"

require 'logger'
require 'stringio'
require 'tmpdir'

class LoggerSingletonTest < Test::Unit::TestCase
  include TestHelper

  library 'logger'
  testing "singleton(::Logger)"

  def setup
    @tmpdir = Dir.mktmpdir
    @path = File.join(@tmpdir, 't.log')
  end

  def teardown
    FileUtils.remove_entry(@tmpdir)
  end

  def test_new
    assert_send_type  "(String) -> Logger",
                      Logger, :new, @path
    assert_send_type  "(IO) -> Logger",
                      Logger, :new, $stdout
    assert_send_type  "(nil) -> Logger",
                      Logger, :new, nil
    assert_send_type  "(Logger::LogDevice) -> Logger",
                      Logger, :new, Logger.new(StringIO.new).logdev
    assert_send_type  "(String, Integer) -> Logger",
                      Logger, :new, @path, 3
    assert_send_type  "(String, Integer, Integer) -> Logger",
                      Logger, :new, @path, 3, 10485760
    assert_send_type  "(String, String) -> Logger",
                      Logger, :new, @path, 'daily'
  end

  def test_new_with_options
    assert_send_type  "(String, level: Integer) -> Logger",
                      Logger, :new, @path, level: Logger::ERROR
    assert_send_type  "(String, level: String) -> Logger",
                      Logger, :new, @path, level: 'error'
    assert_send_type  "(String, level: Symbol) -> Logger",
                      Logger, :new, @path, level: :error
    assert_send_type  "(String, progname: String) -> Logger",
                      Logger, :new, @path, progname: 'mung'
    assert_send_type  "(String, formatter: Proc) -> Logger",
                      Logger, :new, @path, formatter: proc { |severity, time, progname, msg| "#{msg}\n" }
    assert_send_type  "(String, datetime_format: String) -> Logger",
                      Logger, :new, @path, datetime_format: '%Y-%m-%d %H:%M:%S'
    assert_send_type  "(String, binmode: bool) -> Logger",
                      Logger, :new, @path, binmode: true
    assert_send_type  "(String, shift_period_suffix: String) -> Logger",
                      Logger, :new, @path, shift_period_suffix: '%Y-%m-%d'
    assert_send_type  "(String, reraise_write_errors: Array[singleton(IOError)]) -> Logger",
                      Logger, :new, @path, reraise_write_errors: [IOError]
    assert_send_type  "(String, skip_header: bool) -> Logger",
                      Logger, :new, @path, skip_header: true
  end
end

class LoggerTest < Test::Unit::TestCase
  include TestHelper

  library 'logger'
  testing "::Logger"

  def logger
    Logger.new(StringIO.new, progname: 'mung')
  end

  def test_left_shift
    assert_send_type  "(String) -> untyped",
                      logger, :<<, 'My message.'
  end

  def test_add
    assert_send_type  "(Integer) -> true",
                      logger, :add, Logger::INFO
    assert_send_type  "(Integer, String) -> true",
                      logger, :add, Logger::ERROR, 'No good'
    assert_send_type  "(Integer, String, String) -> true",
                      logger, :add, Logger::ERROR, 'No good', 'gnum'
    assert_send_type  "(Integer) { () -> String } -> true",
                      logger, :add, Logger::INFO do 'My message' end
  end

  def test_log
    assert_send_type  "(Integer, String) -> true",
                      logger, :log, Logger::ERROR, 'No good'
  end

  def test_close
    assert_send_type  "() -> untyped",
                      logger, :close
  end

  def test_datetime_format
    assert_send_type  "() -> String?",
                      logger, :datetime_format
  end

  def test_datetime_format=
    assert_send_type  "(String) -> String",
                      logger, :datetime_format=, '%Y-%m-%d %H:%M:%S'
    assert_send_type  "(nil) -> nil",
                      logger, :datetime_format=, nil
  end

  def test_debug
    assert_send_type  "() -> true",
                      logger, :debug
    assert_send_type  "(String) -> true",
                      logger, :debug, 'Maximal debugging info'
    assert_send_type  "(String) { () -> String } -> true",
                      logger, :debug, 'mung' do 'Maximal debugging info' end
  end

  def test_debug!
    assert_send_type  "() -> Integer",
                      logger, :debug!
  end

  def test_debug?
    assert_send_type  "() -> bool",
                      logger, :debug?
  end

  def test_info
    assert_send_type  "() -> true",
                      logger, :info
    assert_send_type  "(String) -> true",
                      logger, :info, 'Non-error information'
    assert_send_type  "(String) { () -> String } -> true",
                      logger, :info, 'mung' do 'Non-error information' end
  end

  def test_info!
    assert_send_type  "() -> Integer",
                      logger, :info!
  end

  def test_info?
    assert_send_type  "() -> bool",
                      logger, :info?
  end

  def test_warn
    assert_send_type  "() -> true",
                      logger, :warn
    assert_send_type  "(String) -> true",
                      logger, :warn, 'Non-error warning'
    assert_send_type  "(String) { () -> String } -> true",
                      logger, :warn, 'mung' do 'Non-error warning' end
  end

  def test_warn!
    assert_send_type  "() -> Integer",
                      logger, :warn!
  end

  def test_warn?
    assert_send_type  "() -> bool",
                      logger, :warn?
  end

  def test_error
    assert_send_type  "() -> true",
                      logger, :error
    assert_send_type  "(String) -> true",
                      logger, :error, 'Non-fatal error'
    assert_send_type  "(String) { () -> String } -> true",
                      logger, :error, 'mung' do 'Non-fatal error' end
  end

  def test_error!
    assert_send_type  "() -> Integer",
                      logger, :error!
  end

  def test_error?
    assert_send_type  "() -> bool",
                      logger, :error?
  end

  def test_fatal
    assert_send_type  "() -> true",
                      logger, :fatal
    assert_send_type  "(String) -> true",
                      logger, :fatal, 'Fatal error'
    assert_send_type  "(String) { () -> String } -> true",
                      logger, :fatal, 'mung' do 'Fatal error' end
  end

  def test_fatal!
    assert_send_type  "() -> Integer",
                      logger, :fatal!
  end

  def test_fatal?
    assert_send_type  "() -> bool",
                      logger, :fatal?
  end

  def test_unknown
    assert_send_type  "() -> true",
                      logger, :unknown
    assert_send_type  "(String) -> true",
                      logger, :unknown, 'Most severe'
    assert_send_type  "(String) { () -> String } -> true",
                      logger, :unknown, 'mung' do 'Most severe' end
  end

  def test_formatter
    assert_send_type  "() -> Logger::_Formatter?",
                      logger, :formatter
  end

  def test_formatter=
    assert_send_type  "(Proc) -> Proc",
                      logger, :formatter=, proc { |severity, time, progname, msg| "#{msg}\n" }
    assert_send_type  "(Logger::Formatter) -> Logger::Formatter",
                      logger, :formatter=, Logger::Formatter.new
    assert_send_type  "(nil) -> nil",
                      logger, :formatter=, nil
  end

  def test_level
    assert_send_type  "() -> Integer",
                      logger, :level
  end

  def test_level=
    assert_send_type  "(Integer) -> Integer",
                      logger, :level=, Logger::ERROR
    assert_send_type  "(String) -> Integer",
                      logger, :level=, 'error'
    assert_send_type  "(Symbol) -> Integer",
                      logger, :level=, :error
  end

  def test_sev_threshold
    assert_send_type  "() -> Integer",
                      logger, :sev_threshold
  end

  def test_sev_threshold=
    assert_send_type  "(Symbol) -> Integer",
                      logger, :sev_threshold=, :error
  end

  def test_logdev
    assert_send_type  "() -> Logger::LogDevice?",
                      logger, :logdev
  end

  def test_progname
    assert_send_type  "() -> untyped",
                      logger, :progname
  end

  def test_progname=
    assert_send_type  "(String) -> String",
                      logger, :progname=, 'mung'
  end

  def test_reopen
    assert_send_type  "() -> Logger",
                      logger, :reopen
    assert_send_type  "(StringIO) -> Logger",
                      logger, :reopen, StringIO.new
    Dir.mktmpdir do |dir|
      path = File.join(dir, 't.log')
      assert_send_type  "(String, Integer, Integer) -> Logger",
                        logger, :reopen, path, 3, 10485760
      assert_send_type  "(String, String, nil, shift_period_suffix: String, binmode: bool) -> Logger",
                        logger, :reopen, path, 'daily', nil, shift_period_suffix: '%Y-%m-%d', binmode: true
    end
  end

  def test_with_level
    assert_send_type  "(Symbol) { () -> String } -> String",
                      logger, :with_level, :debug do 'Hello' end
    assert_send_type  "(Integer) { () -> String } -> String",
                      logger, :with_level, Logger::DEBUG do 'Hello' end
  end
end
