require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Restfulie::Client::HTTP::LinkHeader do
  
  context "when parsing the link header" do
    
    it "returns all the parts if present" do
      @headers = {"link"=>["<http://amundsen.com/examples/mazes/2d/ten-by-ten/0:north>; rel=\"start\"; type=\"application/xml\""]}
      @headers.extend Restfulie::Client::HTTP::LinkHeader
      start = @headers.link("start")
      start.rel.should == "start"
      start.href.should == "http://amundsen.com/examples/mazes/2d/ten-by-ten/0:north"
      start.content_type.should == "application/xml"
    end
    
    it "returns empty if one part is not present" do
      @headers = {"link"=>["<http://amundsen.com/examples/mazes/2d/ten-by-ten/0:north>; rel=\"start\";"]}
      @headers.extend Restfulie::Client::HTTP::LinkHeader
      start = @headers.link("start")
      start.content_type.should be_nil
    end
    
    it "returns nil if the link is not present" do
      @headers = {"link"=>["<http://amundsen.com/examples/mazes/2d/ten-by-ten/0:north>; rel=\"start\""]}
      @headers.extend Restfulie::Client::HTTP::LinkHeader
      @headers.link("south").should be_nil
    end
    
  end

end
