# frozen_string_literal: true

# coding: US-ASCII

require 'logger'
require 'time'

class TestLogPeriod < Test::Unit::TestCase
  def test_next_rotate_time
    time = Time.parse('2019-07-18 13:52:02')

    assert_next_rotate_time_words(time, '2019-07-19 00:00:00',
                                  ['daily', :daily])
    assert_next_rotate_time_words(time, '2019-07-21 00:00:00',
                                  ['weekly', :weekly])
    assert_next_rotate_time_words(time, '2019-08-01 00:00:00',
                                  ['monthly', :monthly])

    assert_raise(ArgumentError) do
      Logger::Period.next_rotate_time(time, 'invalid')
    end
  end

  def test_next_rotate_time_dst_begin
    tz = ENV.fetch('TZ', nil)
    ENV['TZ'] = 'America/New_York' # 1 hour shift
    time = Time.parse('2025-03-09 00:52:02')

    assert_next_rotate_time_words(time, '2025-03-10 00:00:00',
                                  ['daily', :daily])
    assert_next_rotate_time_words(time, '2025-03-16 00:00:00',
                                  ['weekly', :weekly])
    assert_next_rotate_time_words(time, '2025-04-01 00:00:00',
                                  ['monthly', :monthly])

    ENV['TZ'] = 'Antarctica/Troll' # 2 hour shift
    time = Time.parse('2025-03-30 00:52:02')

    assert_next_rotate_time_words(time, '2025-03-31 00:00:00',
                                  ['daily', :daily])
    assert_next_rotate_time_words(time, '2025-04-06 00:00:00',
                                  ['weekly', :weekly])
    assert_next_rotate_time_words(time, '2025-04-01 00:00:00',
                                  ['monthly', :monthly])

    ENV['TZ'] = 'Australia/Lord_Howe' # 30 minute shift
    time = Time.parse('2025-04-06 00:52:02')

    assert_next_rotate_time_words(time, '2025-04-07 00:00:00',
                                  ['daily', :daily])
    assert_next_rotate_time_words(time, '2025-04-13 00:00:00',
                                  ['weekly', :weekly])
    assert_next_rotate_time_words(time, '2025-05-01 00:00:00',
                                  ['monthly', :monthly])

    ENV['TZ'] = 'Asia/Gaza' # 1 hour shift on Saturday
    time = Time.parse('2025-04-12 00:52:02')

    assert_next_rotate_time_words(time, '2025-04-13 00:00:00',
                                  ['daily', :daily])
    assert_next_rotate_time_words(time, '2025-04-13 00:00:00',
                                  ['weekly', :weekly])
    assert_next_rotate_time_words(time, '2025-05-01 00:00:00',
                                  ['monthly', :monthly])

    ENV['TZ'] = tz
  end

  def test_next_rotate_time_dst_end
    tz = ENV.fetch('TZ', nil)
    ENV['TZ'] = 'America/New_York' # 1 hour shift
    time = Time.parse('2025-11-02 13:52:02')

    assert_next_rotate_time_words(time, '2025-11-03 00:00:00',
                                  ['daily', :daily])
    assert_next_rotate_time_words(time, '2025-11-09 00:00:00',
                                  ['weekly', :weekly])
    assert_next_rotate_time_words(time, '2025-12-01 00:00:00',
                                  ['monthly', :monthly])

    ENV['TZ'] = 'Antarctica/Troll' # 2 hour shift
    time = Time.parse('2025-10-26 13:52:02')

    assert_next_rotate_time_words(time, '2025-10-27 00:00:00',
                                  ['daily', :daily])
    assert_next_rotate_time_words(time, '2025-11-02 00:00:00',
                                  ['weekly', :weekly])
    assert_next_rotate_time_words(time, '2025-11-01 00:00:00',
                                  ['monthly', :monthly])

    ENV['TZ'] = 'Australia/Lord_Howe' # 30 minute shift
    time = Time.parse('2025-10-05 13:52:02')

    assert_next_rotate_time_words(time, '2025-10-06 00:00:00',
                                  ['daily', :daily])
    assert_next_rotate_time_words(time, '2025-10-12 00:00:00',
                                  ['weekly', :weekly])
    assert_next_rotate_time_words(time, '2025-11-01 00:00:00',
                                  ['monthly', :monthly])

    ENV['TZ'] = 'Asia/Gaza' # 1 hour shift on Saturday
    time = Time.parse('2025-10-25 13:52:02')

    assert_next_rotate_time_words(time, '2025-10-26 00:00:00',
                                  ['daily', :daily])
    assert_next_rotate_time_words(time, '2025-10-26 00:00:00',
                                  ['weekly', :weekly])
    assert_next_rotate_time_words(time, '2025-11-01 00:00:00',
                                  ['monthly', :monthly])

    ENV['TZ'] = tz
  end

  def test_next_rotate_time_extreme_cases
    # First day of Month and Saturday
    time = Time.parse('2018-07-01 00:00:00')

    assert_next_rotate_time_words(time, '2018-07-02 00:00:00',
                                  ['daily', :daily])
    assert_next_rotate_time_words(time, '2018-07-08 00:00:00',
                                  ['weekly', :weekly])
    assert_next_rotate_time_words(time, '2018-08-01 00:00:00',
                                  ['monthly', :monthly])

    assert_raise(ArgumentError) do
      Logger::Period.next_rotate_time(time, 'invalid')
    end
  end

  def test_previous_period_end
    time = Time.parse('2019-07-18 13:52:02')

    assert_previous_period_end_words(time, '2019-07-17 23:59:59',
                                     ['daily', :daily])
    assert_previous_period_end_words(time, '2019-07-13 23:59:59',
                                     ['weekly', :weekly])
    assert_previous_period_end_words(time, '2019-06-30 23:59:59',
                                     ['monthly', :monthly])

    assert_raise(ArgumentError) do
      Logger::Period.previous_period_end(time, 'invalid')
    end
  end

  def test_previous_period_end_dst_begin
    tz = ENV.fetch('TZ', nil)
    ENV['TZ'] = 'America/New_York' # 1 hour shift
    time = Time.parse('2025-03-09 00:52:02')

    assert_previous_period_end_words(time, '2025-03-08 23:59:59',
                                     ['daily', :daily])
    assert_previous_period_end_words(time, '2025-03-08 23:59:59',
                                     ['weekly', :weekly])
    assert_previous_period_end_words(time, '2025-02-28 23:59:59',
                                     ['monthly', :monthly])

    ENV['TZ'] = 'Antarctica/Troll' # 2 hour shift
    time = Time.parse('2025-03-30 00:52:02')

    assert_previous_period_end_words(time, '2025-03-29 23:59:59',
                                     ['daily', :daily])
    assert_previous_period_end_words(time, '2025-03-29 23:59:59',
                                     ['weekly', :weekly])
    assert_previous_period_end_words(time, '2025-02-28 23:59:59',
                                     ['monthly', :monthly])

    ENV['TZ'] = 'Australia/Lord_Howe' # 30 minute shift
    time = Time.parse('2025-04-06 00:52:02')

    assert_previous_period_end_words(time, '2025-04-05 23:59:59',
                                     ['daily', :daily])
    assert_previous_period_end_words(time, '2025-04-05 23:59:59',
                                     ['weekly', :weekly])
    assert_previous_period_end_words(time, '2025-03-31 23:59:59',
                                     ['monthly', :monthly])

    ENV['TZ'] = 'Asia/Gaza' # 1 hour shift on Saturday
    time = Time.parse('2025-04-12 00:52:02')

    assert_previous_period_end_words(time, '2025-04-11 23:59:59',
                                     ['daily', :daily])
    assert_previous_period_end_words(time, '2025-04-05 23:59:59',
                                     ['weekly', :weekly])
    assert_previous_period_end_words(time, '2025-03-31 23:59:59',
                                     ['monthly', :monthly])

    ENV['TZ'] = tz
  end

  def test_previous_period_end_dst_end
    tz = ENV.fetch('TZ', nil)
    ENV['TZ'] = 'America/New_York' # 1 hour shift
    time = Time.parse('2025-11-02 13:52:02')

    assert_previous_period_end_words(time, '2025-11-01 23:59:59',
                                     ['daily', :daily])
    assert_previous_period_end_words(time, '2025-11-01 23:59:59',
                                     ['weekly', :weekly])
    assert_previous_period_end_words(time, '2025-10-31 23:59:59',
                                     ['monthly', :monthly])

    ENV['TZ'] = 'Antarctica/Troll' # 2 hour shift
    time = Time.parse('2025-10-26 13:52:02')

    assert_previous_period_end_words(time, '2025-10-25 23:59:59',
                                     ['daily', :daily])
    assert_previous_period_end_words(time, '2025-10-25 23:59:59',
                                     ['weekly', :weekly])
    assert_previous_period_end_words(time, '2025-09-30 23:59:59',
                                     ['monthly', :monthly])

    ENV['TZ'] = 'Australia/Lord_Howe' # 30 minute shift
    time = Time.parse('2025-10-05 13:52:02')

    assert_previous_period_end_words(time, '2025-10-04 23:59:59',
                                     ['daily', :daily])
    assert_previous_period_end_words(time, '2025-10-04 23:59:59',
                                     ['weekly', :weekly])
    assert_previous_period_end_words(time, '2025-09-30 23:59:59',
                                     ['monthly', :monthly])

    ENV['TZ'] = 'Asia/Gaza' # 1 hour shift on Saturday
    time = Time.parse('2025-10-25 13:52:02')

    assert_previous_period_end_words(time, '2025-10-24 23:59:59',
                                     ['daily', :daily])
    assert_previous_period_end_words(time, '2025-10-18 23:59:59',
                                     ['weekly', :weekly])
    assert_previous_period_end_words(time, '2025-09-30 23:59:59',
                                     ['monthly', :monthly])
    ENV['TZ'] = tz
  end

  def test_previous_period_end_extreme_cases
    # First day of Month and Saturday
    time = Time.parse('2018-07-01 00:00:00')
    previous_date = '2018-06-30 23:59:59'

    assert_previous_period_end_words(time, previous_date, ['daily', :daily])
    assert_previous_period_end_words(time, previous_date, ['weekly', :weekly])
    assert_previous_period_end_words(time, previous_date, ['monthly', :monthly])

    assert_raise(ArgumentError) do
      Logger::Period.previous_period_end(time, 'invalid')
    end
  end

  private

  def assert_next_rotate_time_words(time, next_date, words)
    assert_time_words(:next_rotate_time, time, next_date, words)
  end

  def assert_previous_period_end_words(time, previous_date, words)
    assert_time_words(:previous_period_end, time, previous_date, words)
  end

  def assert_time_words(method, time, date, words)
    words.each do |word|
      daily_result = Logger::Period.public_send(method, time, word)
      expected_result = Time.parse(date)
      assert_equal(expected_result, daily_result)
    end
  end
end
