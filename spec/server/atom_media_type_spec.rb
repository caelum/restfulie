require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class City
  extend Restfulie::MediaTypeControl
  media_type 'application/vnd.caelum_city+xml'
end

context Restfulie::Server::AtomMediaType do
  
  it "should support atom feed media type by default" do
    atom = Restfulie::MediaType.media_types['application/atom+xml']
    Array.media_types.include?(atom).should be_true
  end

  it "array serialization to atom will serialize every element" do
    [City.new, City.new]
    false.should be_true
  end
  
end