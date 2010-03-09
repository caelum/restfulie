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
      builder = describe(Object.new)
      builder.should be_kind_of(Restfulie::Builder::Base)
    end
    
    it "should create a entry rule and set in builder rules" do
      block   = lambda {}
      builder = describe(Object.new, &block)
      builder.rules.should_not be_blank()
      builder.rules.find { |r| r.block == block }.should be_kind_of(Restfulie::Builder::MemberRule)
    end
  end # context "entry"
  
  context "collection" do
    it "should create a builder for a simple call" do
      builder = describe([])
      builder.should be_kind_of(Restfulie::Builder::Base)
    end
    
    it "should create a entry rule and set in builder rules" do
      block   = lambda {}
      builder = describe([], &block)
      builder.rules.should_not be_blank()
      builder.rules.find { |r| r.block == block }.should be_kind_of(Restfulie::Builder::CollectionRule)
    end
  end # context "entry"
end