require 'spec_helper'

describe Restfulie::Client::Feature::Verb do
  
  before do
    @request = Object.new
    @request.extend Restfulie::Client::Feature::Verb
  end
  
  context "when invoking throw error based methods" do
    
    it "should invoke throw error and delegate invocations on get" do
      @request.should_receive(:request).with(:throw_error_request)
      @request.should_receive(:get).with({:key => :value})
      @request.get!({:key => :value})
    end
    
    ["head", "delete"].each do |method|
      it "should invoke throw error and delegate invocations on #{method}" do
        @request.should_receive(:request).with(:throw_error_request)
        @request.should_receive(method)
        @request.send "#{method}!"
      end
    end

    ["put", "post", "patch"].each do |method|
      it "should invoke throw error and delegate invocations on #{method}" do
        body = "{ 'data' : 'content' }"
        @request.should_receive(:request).with(:throw_error_request)
        @request.should_receive(method).with(body)
        @request.send "#{method}!", body
      end
    end

  end

end
