require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

context Restfulie::Common::Converter::Atom::Namespace do
  it "should extender Hash" do
    Restfulie::Common::Converter::Atom::Namespace.ancestors.should be_include(HashWithIndifferentAccess)
  end
  
  context "create" do
    before do 
      @ns = Restfulie::Common::Converter::Atom::Namespace.new('album', "http://albums.example.com")
    end
    
    it "should respond the namespace attribute" do
      @ns.namespace.should == :album
      @ns.uri.should == "http://albums.example.com"
    end

    it "should auto insert a method not fould" do
      title = "Entry Song"
      @ns.title = title
      @ns.should be_include(:title)
      @ns.title.should == title
    end
    
    it "should raise error method is not implemented" do
      lambda {
        @ns.foobar
      }.should raise_error(NoMethodError,  "undefined method `foobar' for {}:#{@ns.class.to_s}")
    end
    
    it "should not allow blank uri" do
      lambda {
        @ns.uri = nil
      }.should raise_error(Restfulie::Common::Error::NameSpaceError, 'Namespace can not be blank uri.')
    end
  end # context "create"
end
