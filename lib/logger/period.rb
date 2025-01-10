# frozen_string_literal: true

require 'date'

class Logger
  module Period
    module_function

    def next_rotate_time(now, shift_age)
      case shift_age
      when 'daily', :daily
        (now.to_date + 1).to_time
      when 'weekly', :weekly
        (now.to_date + 7 - now.wday).to_time
      when 'monthly', :monthly
        if now.month == 12
          Time.mktime(now.year + 1, 1, 1)
        else
          Time.mktime(now.year, now.month + 1, 1)
        end
      when 'now', 'everytime', :now, :everytime
        now
      else
        raise ArgumentError, "invalid :shift_age #{shift_age.inspect}, should be daily, weekly, monthly, or everytime"
      end
    end

    def previous_period_end(now, shift_age)
      case shift_age
      when 'daily', :daily
        now.to_date.to_time - 1
      when 'weekly', :weekly
        (now.to_date - now.wday).to_time - 1
      when 'monthly', :monthly
        Time.mktime(now.year, now.month, 1) - 1
      when 'now', 'everytime', :now, :everytime
        now
      else
        raise ArgumentError, "invalid :shift_age #{shift_age.inspect}, should be daily, weekly, monthly, or everytime"
      end
    end
  end
end
