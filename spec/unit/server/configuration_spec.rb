require 'spec_helper'

describe Restfulie::Server::Configuration do
  
  it "setup should yield self" do
    Restfulie::Server::Configuration.setup do |config|
      config.should equal Restfulie::Server::Configuration
    end
  end
  
  
  context "save configurations in Restfulie::Server" do

    before do
      Restfulie::Server::Configuration.setup do |config|
        config.host = "myhost.com"
        config.named_route_prefix = :prefix
      end      
    end
    
    it "should have a default host configuration" do
      Restfulie::Server::Configuration.host.should eql "myhost.com"
    end
    
    it  "should have a default named route prefix" do
      Restfulie::Server::Configuration.named_route_prefix.should equal :prefix
    end
    
  end
  
  after(:all) do
    Restfulie::Server::Configuration.host = "localhost:3000"
    Restfulie::Server::Configuration.named_route_prefix = nil
  end
end

