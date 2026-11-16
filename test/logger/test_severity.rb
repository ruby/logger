# coding: US-ASCII
# frozen_string_literal: false
require 'logger'

class TestLoggerSeverity < Test::Unit::TestCase
  include Logger::Severity

  def test_enum
    logger_levels = Logger.constants
    levels = ["WARN", "UNKNOWN", "INFO", "FATAL", "DEBUG", "ERROR"]
    Logger::Severity.constants.each do |level|
      assert(levels.include?(level.to_s))
      assert(logger_levels.include?(level))
    end
    assert_equal(levels.size, Logger::Severity.constants.size)
  end

  def test_level_assignment
    logger = Logger.new(nil)

    Logger::Severity.constants.each do |level|
      next if level == :UNKNOWN

      logger.send("#{level.downcase}!")
      assert(logger.level) == Logger::Severity.const_get(level)
    end
  end

  def test_fiber_local_level
    logger = Logger.new(nil)
    logger.level = INFO # default level
    other = Logger.new(nil)
    other.level = ERROR # default level

    assert_equal(other.level, ERROR)
    logger.with_level(:WARN) do
      assert_equal(other.level, ERROR)
      assert_equal(logger.level, WARN)

      logger.with_level(DEBUG) do # verify reentrancy
        assert_equal(logger.level, DEBUG)

        Fiber.new do
          assert_equal(logger.level, INFO)
          logger.with_level(:WARN) do
            assert_equal(other.level, ERROR)
            assert_equal(logger.level, WARN)
          end
          assert_equal(logger.level, INFO)
        end.resume

        assert_equal(logger.level, DEBUG)
      end
      assert_equal(logger.level, WARN)
    end
    assert_equal(logger.level, INFO)
  end

  def test_level_assignment_after_with_level
    logger = Logger.new(nil)
    logger.level = INFO

    logger.with_level(:DEBUG) do
      logger.with_level(:WARN) {}
      assert_equal(DEBUG, logger.level)
    end
    logger.level = ERROR

    assert_equal(ERROR, logger.level)
  end

  def test_with_level_releases_level_key
    logger = Logger.new(nil)

    Fiber.new { logger.with_level(:WARN) {} }.resume
    logger.with_level(:WARN) {}
    assert_raise(RuntimeError) { logger.with_level(:WARN) { raise "boom" } }

    assert_empty(logger.instance_variable_get(:@level_override))
  end

  def test_thread_local_level
    subclass = Class.new(Logger) do
      def level_key
        Thread.current
      end
    end

    logger = subclass.new(nil)
    logger.level = INFO # default level
    other = subclass.new(nil)
    other.level = ERROR # default level

    assert_equal(other.level, ERROR)
    logger.with_level(:WARN) do
      assert_equal(other.level, ERROR)
      assert_equal(logger.level, WARN)

      logger.with_level(DEBUG) do # verify reentrancy
        assert_equal(logger.level, DEBUG)

        Fiber.new do
          assert_equal(logger.level, DEBUG)
          logger.with_level(:WARN) do
            assert_equal(other.level, ERROR)
            assert_equal(logger.level, WARN)
          end
          assert_equal(logger.level, DEBUG)
        end.resume

        assert_equal(logger.level, DEBUG)
      end
      assert_equal(logger.level, WARN)
    end
    assert_equal(logger.level, INFO)
  end
end
