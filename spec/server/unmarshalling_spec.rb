require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie::Server::Base do
  
  context "while registering a mime type" do
    it "should be able to unmarshall the data" do
      class City
        extend Restfulie::MediaTypeControl
        media_type 'vnd/caelum_city+xml'
        attr_reader :name
      end
      content = "my custom content"
      
      body = Object.new
      body.should_receive(:string).and_return(content)
      
      request = Object.new
      request.should_receive(:body).and_return(body)
      
      result = Object.new
      City.should_receive(:from_xml).and_return(result)
      city = Restfulie.from request
      city.should eql(result)
      
    end
  end
  
end

