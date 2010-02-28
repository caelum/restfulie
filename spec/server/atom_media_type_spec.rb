require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class City
  extend Restfulie::MediaTypeControl
  media_type 'application/vnd.caelum_city+xml'
end

context Restfulie::Server::AtomMediaType do
  
  before do
    @now = Time.now
  end
  
  context Array do

    it "should support atom feed media type by default" do
      Array.media_type_representations.should include('application/atom+xml')
    end
  end
end