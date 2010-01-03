require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class City
  extend Restfulie::MediaTypeControl
  media_type 'application/vnd.caelum_city+xml'
end

context Restfulie::Server::AtomMediaType do

  describe Restfulie::Server::AtomMediaType do
    
    it "should create an atom feed decoded" do
      feed = Object.new
      first = Object.new
      Hash.should_receive(:from_xml).with("<order></order>").and_return({ :first_key => first})
      Restfulie::Server::AtomFeedDecoded.should_receive(:new).with(first).and_return(feed)
      result = Restfulie::Server::AtomMediaType.from_xml "<order></order>"
      result.should eql(feed)
    end
    
  end

  describe Restfulie::Server::AtomFeedDecoded do
    
    before do
      @hotel = {"hotel" => {:name => "caelum"}}
    end
    
    it "should access an entry position's content by using brackets" do
      result = Object.new
      entry = Hashi::CustomHash.new
      entry.content = Hashi::CustomHash.new(@hotel)
      feed = Restfulie::Server::AtomFeedDecoded.new({ "entry" => [entry] })
      Restfulie::MediaType::DefaultMediaTypeDecoder.should_receive(:from_hash).with(@hotel).and_return(result)
      feed[0].should eql(result)
    end
    
    it "should ignore the type attribute if its the first one" do
      result = Object.new
      entry = Hashi::CustomHash.new
      @hotel["type"] = "hotel"
      entry.content = Hashi::CustomHash.new(@hotel)
      feed = Restfulie::Server::AtomFeedDecoded.new({ "entry" => [entry] })
      Restfulie::MediaType::DefaultMediaTypeDecoder.should_receive(:from_hash).with({"hotel" => {:name => "caelum"}}).and_return(result)
      feed[0].should eql(result)
    end
    
  end
  
end