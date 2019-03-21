require 'stringio'

class Logger
  class Buffer
    def initialize(io = StringIO.new, prefix = '[...]')
      @io = io
      @prefix = prefix
    end
    
    attr :io
    
    def puts(*args)
      args.each do |arg|
        @io.puts "#{@prefix}#{arg}"
      end
    end
  end
end
