require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/models')

context Restfulie::Common::Builder::Helpers do
  include Restfulie::Common::Builder::Helpers
  
  context "parts" do
    it "create a Link" do
      lk = link(:self)
      lk.should be_kind_of(Restfulie::Common::Builder::Rules::Link)
    end

    it "create a text content" do
      content = text("Text")
      content.should be_kind_of(Atom::Content::Text)
    end
    
    it "create a html content" do
      content = html('<a name="anchor">Anchor</a>')
      content.should be_kind_of(Atom::Content::Html)
    end

    it "create a xhtml content" do
      content = xhtml('<a name="anchor">Anchor</a>')
      content.should be_kind_of(Atom::Content::Xhtml)
    end
  end

  context "member" do
    it "should create a builder for a simple call" do
      builder = describe_member(Object.new)
      builder.should be_kind_of(Restfulie::Common::Builder::Base)
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
      builder.should be_kind_of(Restfulie::Common::Builder::Base)
    end
    
    it "should create a entry rule and set in builder rules" do
      block   = lambda {}
      builder = describe_collection([], {}, &block)
      
      builder.rules_blocks.should_not be_blank()
      builder.rules_blocks.should be_include(block)
    end
  end # context "entry"
end
