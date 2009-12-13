require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

context Restfulie::Server::Base do
  
  context "while registering a mime type" do
    
    it "should be able to locate it" do
      class City
        extend Restfulie::MediaTypeControl
        media_type 'vnd/caelum_city+xml'
      end
      Restfulie::MediaType.media_type('vnd/caelum_city+xml').should eql(City)
    end

    it "should be able to locate with encoding" do
      class City
        extend Restfulie::MediaTypeControl
        media_type 'vnd/caelum_city+xml'
      end
      Restfulie::MediaType.media_type('vnd/caelum_city+xml; charset=UTF-8').should eql(City)
    end
    
    it "should throw an exception if not found" do
      lambda {Restfulie::MediaType.media_type('vnd/caelum_unknown_city+xml')}.should raise_error(Restfulie::UnsupportedContentType)
    end
    
    it "should notify when not supported" do
      class Country
        extend Restfulie::MediaTypeControl
        media_type 'vnd/country+xml'
      end
      Restfulie::MediaType.supports('vnd/country+xml').should be_true
      Restfulie::MediaType.supports('vnd/caelum_unknown_city+xml').should be_false
      lambda {Restfulie::MediaType.media_type('vnd/caelum_unknown_city+xml')}.should raise_error(Restfulie::UnsupportedContentType)
    end
    
    it "should be able to register more than one" do
      class City
        extend Restfulie::MediaTypeControl
        media_type 'vnd/caelum_city+xml', 'vnd/caelum_city+json'
      end
      Restfulie::MediaType.media_type('vnd/caelum_city+xml').should eql(City)
      Restfulie::MediaType.media_type('vnd/caelum_city+json').should eql(City)
    end
    
  end
  
end
