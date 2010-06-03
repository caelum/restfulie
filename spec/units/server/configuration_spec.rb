require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie::Server::Configuration do
  
  it "setup should yield self" do
    Restfulie::Server::Configuration.setup do |config|
      config.should == Restfulie::Server::Configuration
    end
  end
  
  it "saves configurations in Restfulie::Server" do
    Restfulie::Server::Configuration.setup do |config|
      config.host = "myhost.com"
      config.named_route_prefix = :prefix
    end
    
    Restfulie::Server::Configuration.host.should == "myhost.com"
    Restfulie::Server::Configuration.named_route_prefix.should == :prefix
  end
  
  after(:all) do
    Restfulie::Server::Configuration.host = "localhost:3000"
    Restfulie::Server::Configuration.named_route_prefix = nil
  end
end

