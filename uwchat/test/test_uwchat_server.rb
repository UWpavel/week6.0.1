require "test/unit"
require "rubygems"
require "mocha"

require "uwchat"

class TestChatServer < Test::Unit::TestCase

  def setup
    port = 12345
    @users = %w( user100 user101 user102 )
    clients = {}   
    @test_msg = "test message"
    
    # mocking io  
    @io = stub( 'io_simulation',
      :gets     => "send",
      :puts     => "receive",
      :close    => "closed",
      :closed?  => false,
      :peeraddr => [1, 2, 'localhost'] )
    
    @users.each { |u| clients[u] = @io }
    
    @server = ChatServer.new( port )
    # giving our server few clients
    @server.instance_variable_set( :@clients, clients )
  end
  
  def test_new_user
    # create 'user0'
    @server.new_client( @io )
    
    expected = false
    actual = @server.instance_variable_get( :@clients )["user0"].closed?
    assert_equal expected, actual
  end
  
  def test_uwchat_items
    assert_respond_to( @server, :logger )
    assert_not_nil(ChatServer::PORT)
    assert_not_nil(ChatServer::HOST)
    assert_not_nil(ChatServer::MAXCONS)
  end

  def test_id_incremented
    before = @server.id
    @server.new_client( @io )
    after = @server.id
    assert_not_equal before, after
  end
  
  def test_client_removal
    user = @users.first
    before = @server.instance_variable_get( :@clients ).size
    @server.client_left( user )
    after = @server.instance_variable_get( :@clients ).size
    assert_not_equal before, after
  end
  
  def test_process_msg
    users = @server.instance_variable_get( :@clients ).size
    @io.expects( :puts ).times( users - 1 )    
    assert @server.process_msg( @users.last, @test_msg )
  end
  
  def test_client_quit_request
    user = @users.last
    # test if we still have the user
    assert  @server.instance_variable_get( :@clients )[user]
    
    before = @server.instance_variable_get( :@clients ).size
    @server.process_command( user, "/quit" )
    after = @server.instance_variable_get( :@clients ).size
    
    assert_not_equal before, after
    assert_nil @server.instance_variable_get( :@clients )[user]
  end
  
end