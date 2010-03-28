require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie::Server::HTTP::Unmarshal do
  
  before do
    @headers = {}
    @headers["CONTENT_TYPE"] = "application/vnd+customized"

    @request = Object.new
    @request.should_receive(:headers).and_return(@headers)
  end
  
  it "returns 405 if there is no unmarshaller registered" do
    Restfulie::Server::HTTP::Unmarshal.new.unmarshal(@request)
  end
  
  class CustomUnmarshaller
  end
  
  it "saves configurations in Restfulie::Server" do
    content = "formatted body content"
    
    body = mock Object
    body.should_receive(:read).and_return(content)
    @request.should_receive(:body).and_return(body)
    
    Restfulie::Server::HTTP::Unmarshal.register("application/vnd+customized", CustomUnmarshaller)
    CustomUnmarshaller.should_receive(:unmarshal).with(content)
    Restfulie::Server::HTTP::Unmarshal.new.unmarshal(@request)
  end
  
end

