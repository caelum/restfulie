require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie::Server::Base do
  
  context "while registering a mime type" do
    it "should be able to locate it" do
      class City
        extend Restfulie::MimeTypeControl
        media_type 'vnd/caelum_city+xml'
      end
      Restfulie.from('vnd/caelum_city+xml').should eql(City)
    end
    it "should be able to register more than one" do
      class City
        extend Restfulie::MimeTypeControl
        media_type 'vnd/caelum_city+xml', 'vnd/caelum_city+json'
      end
      Restfulie.from('vnd/caelum_city+xml').should eql(City)
      Restfulie.from('vnd/caelum_city+json').should eql(City)
    end
  end
  
end