require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::LinkShortcut do
  
  class MyLink
    attr_accessor :rel, :type
    def initialize(rel, type)
      @rel = rel
      @type = type if type
    end
  end
  
  class LinkedType
    include Restfulie::Client::LinkShortcut
    
    @@first = MyLink.new("search", nil)
    @@second = MyLink.new("last", "application/atom+xml")
    
    def links
      [@@first, @@second]
    end
  end
  
  it "should return the link itself when there is no type definition" do
    linked_data = LinkedType.new
    linked_data.search.should == linked_data.links[0]
  end
  
  it "should return a prepared link if there is a type" do
    custom = Object.new
    linked_data = LinkedType.new
    rep = Object.new
    Restfulie::Client::HTTP::RequestMarshaller.should_receive(:content_type_for).with("application/atom+xml").and_return(rep)
    linked_data.links[1].should_receive(:accepts).with('application/atom+xml')
    rep.should_receive(:prepare_link_for).with(linked_data.links[1]).and_return(custom)
    linked_data.last.should == custom
  end

end
