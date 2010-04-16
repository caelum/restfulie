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
  
context Atom::Link do

  it "should delegate content type to type" do
    link = Atom::Link.new(:type => "application/xml")
    link.content_type.should == link.type
  end
  
end
