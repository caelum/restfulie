require 'spec_helper'

describe Restfulie::Client::Feature::RescueException do
  
  before do
    @feature = Restfulie::Client::Feature::RescueException.new
    @request = Object.new
    @chain = mock Restfulie::Client::StackNavigator
  end
  
  context "when executing a request" do
    
    it "should return an exception if something bad occurs" do
      exception = mock Exception
      @chain.should_receive(:continue).and_raise(exception)
      @feature.execute(@chain, @request, {})
    end
    
    it "should return the response if everything goes fine" do
      response = mock Net::HTTPResponse
      @chain.should_receive(:continue).and_return(response)
      @feature.execute(@chain, @request, {}).should == response
    end
    
  end

end
