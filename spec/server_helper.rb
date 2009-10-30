#require File.expand_path(File.dirname(__FILE__) + "/../Helper")
require 'rubygems'
require 'rack'
require 'thin'

class MockServer
  def initialize(port = 4000, pause = 1)
    @block = nil
    @parent_thread = Thread.current
    @thread = Thread.new do
      Rack::Handler::WEBrick.run(self, :Port => port)
    end

    sleep pause # give the server time to fire up… YUK!
  end

  def stop
    Thread.kill(@thread)
  end

  def attach(&block)
    @block = block
  end

  def detach()
    @block = nil
  end

  def call(env)
    begin
      raise "Specify a handler for the request using attach(block), the block should return a valid rack response and can test expectations" unless @block
      @block.call(env)
    rescue Exception => e
      @parent_thread.raise e
      [ 500, { 'Content-Type' => 'text/plain', 'Content-Length' => '13' }, [ 'Bad test code' ]]
    end
  end
end