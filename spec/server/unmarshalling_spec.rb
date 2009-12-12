require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie::Server::Base do
  
  context "while registering a mime type" do
    it "should be able to unmarshall the data" do
      class City
      end
      
      body = Object.new
      body.should_receive(:string).and_return("my custom content")
      
      request = Object.new
      request.should_receive(:body).and_return(body)
      request.should_receive(:headers).and_return({"CONTENT_TYPE" => 'vnd/caelum_city+xml'})
      
      Restfulie::MediaType.should_receive(:media_type).with("vnd/caelum_city+xml").and_return(City)
      
      result = Object.new
      City.should_receive(:from_xml).with("my custom content").and_return(result)
      city = Restfulie.from request
      city.should eql(result)
      
    end
  end
  
end

