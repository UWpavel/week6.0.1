module Uwchat
  STUDENT = "Pavel Snagovsky"
  VERSION = '0.0.1'
  
  HOST = 'localhost'
  PORT = 36963
  MAXCONS = 10
  
  def logger(msg)
    puts "[#{Time.now}]: #{msg}"
  end
end

require 'uwchat/server'
require 'uwchat/client'