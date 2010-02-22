require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie::Server do
  
  it "setup should yield self" do
    Restfulie::Server.setup do |config|
      config.should == Restfulie::Server
    end
  end
  
  it "saves configurations in Restfulie::Server" do
    Restfulie::Server.setup do |config|
      config.host = "myhost.com"
      config.named_route_prefix = :prefix
    end
    
    Restfulie::Server.host.should == "myhost.com"
    Restfulie::Server.named_route_prefix == :prefix
  end
  
  after(:all) do
    Restfulie::Server.host = "localhost:3000"
    Restfulie::Server.named_route_prefix = nil
  end
end

