require 'spec_helper'

describe Restfulie::Client::Feature::RetryWhenUnavailable do
  
  before do
    @feature = Restfulie::Client::Feature::RetryWhenUnavailable.new
    @response = mock Net::HTTPResponse
    @request = Object.new
    @chain = mock Restfulie::Client::StackNavigator
    @chain.should_receive(:continue).and_return(@response)
  end
  
  context "when executing a request" do
    
    it "should retry execution by default if response code is 503" do
      second_response = mock Net::HTTPResponse
      @chain.should_receive(:continue).with(@request, {}).and_return(second_response)
      @response.stub(:code).and_return("503")
      @feature.execute(@chain, @request, {}).should == second_response
    end
    
    it "should not retry execution by default if response code is not 503" do
      @response.stub(:code).and_return("404")
      @feature.execute(@chain, @request, {}).should == @response
    end
    
    it "should retry execution with a custom behavior" do
      def @feature.should_retry?(response, env)
        env["force_retry"] == true
      end
      second_response = mock Net::HTTPResponse
      @chain.should_receive(:continue).and_return(second_response)
      @feature.execute(@chain, @request, {"force_retry" => true}).should == second_response
    end
    
  end

end
