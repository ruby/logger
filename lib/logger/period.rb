# frozen_string_literal: true

class Logger
  module Period
    module_function

    SiD = 24 * 60 * 60

    def next_rotate_time(now, shift_age)
      case shift_age
      when 'daily', :daily
        delta = 1
      when 'weekly', :weekly
        delta = 7 - now.wday
      when 'monthly', :monthly
        delta = 32 - now.mday
        mday = 1
      when 'now', 'everytime', :now, :everytime
        return now
      else
        raise ArgumentError, "invalid :shift_age #{shift_age.inspect}, should be daily, weekly, monthly, or everytime"
      end
      t = now + delta * SiD
      if t.hour.nonzero? or t.min.nonzero? or t.sec.nonzero? or (mday && t.mday != mday)
        t = Time.mktime(t.year, t.month, mday || t.mday)
      end
      t
    end

    def previous_period_end(now, shift_age)
      case shift_age
      when 'daily', :daily
        delta = 0
      when 'weekly', :weekly
        delta = now.wday
      when 'monthly', :monthly
        delta = now.mday - 1
      when 'now', 'everytime', :now, :everytime
        return now
      else
        raise ArgumentError, "invalid :shift_age #{shift_age.inspect}, should be daily, weekly, monthly, or everytime"
      end
      t = now - delta * SiD
      Time.mktime(t.year, t.month, t.mday) - 1
    end
  end
end
