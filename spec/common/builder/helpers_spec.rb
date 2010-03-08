require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/models')

context Restfulie::Builder::Helpers do
  include Restfulie::Builder::Helpers

  context "entry" do
    it "should create a builder for a simple call" do
      builder = resource()
      builder.should be_kind_of(Restfulie::Builder::Base)
    end
    
    it "should create a entry rule and set in builder rules" do
      block   = lambda {}
      builder = resource(&block)
      builder.rules.should_not be_blank()
      builder.rules.first.block.should eql(block)
    end

    # context "builder a representation" do
    #   it "should create a simple represenatation" do
    #     album   = Album.first
    #     builder = entry(album)
    #     builder.to_atom().should eql()
    #   end
    # end
    
  end # context "entry"
  
  context "collection" do
    it "should create a builder for a simple call" do
      builder = collection()
      builder.should be_kind_of(Restfulie::Builder::Base)
    end
    
    it "should create a entry rule and set in builder rules" do
      block   = lambda {}
      builder = collection(&block)
      builder.rules.should_not be_blank()
      builder.rules.first.block.should eql(block)
    end
  end # context "entry"
end