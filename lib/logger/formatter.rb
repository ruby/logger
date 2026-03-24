# frozen_string_literal: true

class Logger
  # Default formatter for log messages.
  class Formatter
    Format = "%.1s, %s[%s #%d] %5s -- %s: %s\n"
    DatetimeFormat = "%Y-%m-%dT%H:%M:%S.%6N"

    attr_accessor :datetime_format

    def initialize
      @datetime_format = nil
    end

    def call(severity, time, progname, msg, context: nil)
      context_str = format_context(context)

      context_str << " " unless context_str.empty?

      sprintf(Format, severity, context_str, format_datetime(time), Process.pid, severity, progname, msg2str(msg))
    end

  private

    def format_context(context)
      case context
      when Hash
        filter_map_join(context) { |k, v| "[#{k}=#{v}]" unless v.nil? }
      when Array
        filter_map_join(context) { |v| "[#{v}]" unless v.nil? }
      else
        context.to_s.dup
      end
    end

    def format_datetime(time)
      time.strftime(@datetime_format || DatetimeFormat)
    end

    if RUBY_VERSION >= "2.7.0"
      def filter_map_join(context, &blk)
        context.filter_map(&blk).join(" ")
      end
    else
      def filter_map_join(context, &blk)
        context = context.map(&blk).compact.join(" ")
      end
    end

    def msg2str(msg)
      case msg
      when ::String
        msg
      when ::Exception
        "#{ msg.message } (#{ msg.class })\n#{ msg.backtrace.join("\n") if msg.backtrace }"
      else
        msg.inspect
      end
    end
  end
end
