require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/models')

context Restfulie::Builder::Helpers do
  include Restfulie::Builder::Helpers
  
  context "link" do
    it "create a Link" do
      lk = link(:self)
      lk.should be_kind_of(Restfulie::Builder::Rules::Link)
    end
  end

  context "member" do
    it "should create a builder for a simple call" do
      builder = describe_member(Object.new)
      builder.should be_kind_of(Restfulie::Builder::Base)
    end
    
    it "should create a entry rule and set in builder rules" do
      block   = lambda {}
      builder = describe_member(Object.new, {}, &block)
      builder.rules_blocks.should_not be_blank()
      builder.rules_blocks.should be_include(block)
    end
  end # context "entry"
  
  context "collection" do
    it "should create a builder for a simple call" do
      builder = describe_collection([])
      builder.should be_kind_of(Restfulie::Builder::Base)
    end
    
    it "should create a entry rule and set in builder rules" do
      block   = lambda {}
      builder = describe_collection([], {}, &block)
      builder.rules_blocks.should_not be_blank()
      builder.rules_blocks.should be_include(block)
    end
  end # context "entry"
end