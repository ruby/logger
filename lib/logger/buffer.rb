require 'stringio'

class Logger
  class Buffer
    def initialize(io = StringIO.new, prefix = "\t")
      @io = io
      @first = true
      @prefix = prefix
    end
    
    attr :io
    
    def puts(*args)
      args.each do |arg|
        if @first
          @io.puts arg
          @first = false
        else
          @io.puts "#{@prefix}#{arg}"
        end
      end
    end
  end
end
