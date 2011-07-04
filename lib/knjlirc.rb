class Knjlirc
  attr_reader :events
  
  def initialize(args = {})
    require "knjrbfw"
    require "knj/event_handler"
    require "knj/autoload"
    require "open3"
    
    @args = args
    @events = Knj::Event_handler.new
    @events.add_event(:name => :on_event)
  end
  
  def listen
    @thread = Thread.new do
      @stdin, @stdout, @stderr = Open3.popen3("irw")
      channel = @stdout
      
      begin
        print "Starting listen.\n"
        
        while !channel.closed? and line = channel.gets
          if match = line.match(/^(.+)\s+(\d+)\s+(.+)\s+(.+)$/)
            event_data = {
              :code => match[1],
              :time => match[2].to_i,
              :str => match[3],
              :driver => match[4]
            }
            
            @events.call(:on_event, event_data)
          end
        end
      rescue Exception => e
        puts e.inspect
        puts e.backtrace
      end
    end
  end
  
  def join
    raise "No thread spawned." if !@thread
    @thread.join
  end
  
  def close
    @stdin.close
    @stdout.close
    @stderr.close
  end
end