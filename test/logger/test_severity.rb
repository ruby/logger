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
    clone = logger.clone # should not be chaged

    assert_equal(other.level, ERROR)
    logger.with_level(:WARN) do
      assert_equal(other.level, ERROR)
      assert_equal(logger.level, WARN)
      assert_equal(clone.level, INFO)
      assert_equal(logger.dup.level, INFO)
      assert_equal(logger.clone.level, INFO)
      logger.clone.with_level(:FATAL) do
        assert_equal(logger.level, WARN)
      end

      logger.with_level(DEBUG) do # verify reentrancy
        assert_equal(logger.level, DEBUG)
        assert_equal(clone.level, INFO)

        Fiber.new do
          assert_equal(logger.level, INFO)
          logger.with_level(:WARN) do
            assert_equal(other.level, ERROR)
            assert_equal(logger.level, WARN)
            assert_equal(clone.level, INFO)
            assert_equal(logger.dup.level, INFO)
            assert_equal(logger.clone.level, INFO)
          end
          assert_equal(logger.level, INFO)
        end.resume

        assert_equal(logger.level, DEBUG)
      end
      assert_equal(logger.level, WARN)
    end
    assert_equal(logger.level, INFO)
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
    clone = logger.clone # should not be chaged

    assert_equal(other.level, ERROR)
    logger.with_level(:WARN) do
      assert_equal(other.level, ERROR)
      assert_equal(logger.level, WARN)
      assert_equal(clone.level, INFO)
      assert_equal(logger.dup.level, INFO)
      assert_equal(logger.clone.level, INFO)
      logger.clone.with_level(:FATAL) do
        assert_equal(logger.level, WARN)
      end

      logger.with_level(DEBUG) do # verify reentrancy
        assert_equal(logger.level, DEBUG)
        assert_equal(clone.level, INFO)

        Fiber.new do
          assert_equal(logger.level, DEBUG)
          logger.with_level(:WARN) do
            assert_equal(other.level, ERROR)
            assert_equal(logger.level, WARN)
            assert_equal(clone.level, INFO)
            assert_equal(logger.dup.level, INFO)
            assert_equal(logger.clone.level, INFO)
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
