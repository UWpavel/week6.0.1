require 'socket'

class ChatClient
  include Uwchat

  def initialize( host = HOST, port = PORT )
    begin
      @session = TCPSocket.new( host, port )
    rescue
      raise "Failed to connect to #{host}:#{port}"
    end
    puts "Connected to ChatServer on #{host}. To exit the client: \'exit\'"
  end
  
  def chat
    incoming = Thread.new do
      while msg = @session.gets
        puts msg
      end
    end
     
    outgoing = Thread.new do
      while msg = $stdin.gets.chomp
        exit 0 if msg =~ /disconnect|exit|^quit/
        begin
          @session.puts( msg )
        rescue
          raise "Failed to communicate to the Chat server. Exiting."
        end
      end
    end
    
    incoming.join
    outgoing.join
  end

end