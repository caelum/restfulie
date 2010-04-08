require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::HTTP::AtomElementShortcut do
  
  class Extended
    include Restfulie::Client::HTTP::AtomElementShortcut
    
    attr_reader :simple_extensions
    
    def initialize(h = {})
      @simple_extensions = h
    end
  end

  it "should negate when there is no extension" do
    lambda { Extended.new.price }.should raise_error(NoMethodError)
  end

  it "should return its value when there is only one namespace extension" do
    Extended.new({"{http://namespace,price}" => [10]}).price == 10
  end

  it "should respond to extension name when present" do
    Extended.new({"{http://namespace,price}" => [10]}).should respond_to(:price)
  end

  it "should return an array when its an array in one namespace" do
    Extended.new({"{http://namespace,price}" => [10, 20]}).price == [10, 20]
  end

  it "should return an array when there is more than one namespace extension" do
    Extended.new({"{http://namespace,price}" => [10], "{http://second,price}" => [15]}).price == [10, 15]
  end

  it "should return a bidimensional array when there is more than one namespace extension with extra array" do
    Extended.new({"{http://namespace,price}" => [10, 20], "{http://second,price}" => [15, 30]}).price == [[10, 20], [15,30]]
  end
  
end
  
context Restfulie::Client::HTTP::AtomLinkShortcut do
  
  class MyLink
    attr_accessor :rel, :type
    def initialize(rel, type)
      @rel = rel
      @type = type if type
    end
  end
  
  class LinkedType
    include Restfulie::Client::HTTP::AtomLinkShortcut
    
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

