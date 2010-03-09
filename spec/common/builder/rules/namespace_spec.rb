require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

context Restfulie::Builder::Rules::Namespace do
  it "should extender Hash" do
    Restfulie::Builder::Rules::Namespace.ancestors.should be_include(Hash)
  end

  it "should respond the namespace attribute" do
    ns = Restfulie::Builder::Rules::Namespace.new('album', "http://albums.example.com")
    ns.namespace.should == :album
    ns.uri.should == "http://albums.example.com"
  end

  it "should auto insert a method not fould" do
    title = "Entry Song"
    ns = Restfulie::Builder::Rules::Namespace.new('song')
    ns.title = title
    ns.should be_include(:title)
    ns.title.should == title
  end
end