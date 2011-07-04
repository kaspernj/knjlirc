require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Knjlirc" do
  it "should be able to listen for lirc events" do
    print "Spawning Knjlirc.\n"
    require "knjlirc"
    lirc = Knjlirc.new
    
    print "Connecting events.\n"
    lirc.events.connect(:on_event) do |event, data|
      if data[:time] == 0
        print "Event: #{event}\n"
        Knj::Php.print_r(data)
      end
    end
    
    print "Start listening and join the thread.\n"
    lirc.listen
    #lirc.join
    
    print "Sleeping 2 secs and killing.\n"
    sleep 2
    
    print "Closing.\n"
    lirc.close
  end
end
