require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Restfulie::Client::Feature::ConnegWhenUnaccepted do
  
  before do
    @feature = Restfulie::Client::Feature::ConnegWhenUnaccepted.new
    @response = mock Net::HTTPResponse
    @response.stub("headers").and_return("Accept"=>["application/xml"])
    @request = Object.new
    @chain = mock Restfulie::Client::Parser
    @chain.should_receive(:continue).and_return(@response)
  end
  
  context "when executing a request" do
    
    it "should not retry execution by default if response code is not 406" do
      @response.stub(:code).and_return("404")
      @feature.execute(@chain, @request, @response, {}).should == @response
    end

    it "should not retry execution if there is no content type agreed on" do
      @response.stub(:code).and_return("406")
      Restfulie::Common::Converter.should_receive(:find_for).with(["application/xml"]).and_return(nil)
      @feature.execute(@chain, @request, @response, {}).should == @response
    end

    it "should retry execution by default if response code is 503" do
      env = {:payload => "my payload"}
      
      @response.stub(:code).and_return("406")
      Restfulie::Common::Converter.should_receive(:find_for).with(["application/xml"]).and_return("application/xml")

      @request.should_receive(:with).with("Content-type", "application/xml")
      following = Object.new
      Restfulie::Client::Feature::SerializeBody.should_receive(:new).and_return(following)

      second_response = mock Net::HTTPResponse
      following.should_receive(:execute).with(@chain, @request, @response, env.dup.merge(:body => env[:payload])).and_return(second_response)
      
      @feature.execute(@chain, @request, @response, env).should == second_response
    end
    
  end

end
