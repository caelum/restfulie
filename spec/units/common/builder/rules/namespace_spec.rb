require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

context Restfulie::Common::Builder::Rules::Namespace do
  it "should extender Hash" do
    Restfulie::Common::Builder::Rules::Namespace.ancestors.should be_include(Hash)
  end
  
  context "create" do
    before do 
      @ns = Restfulie::Common::Builder::Rules::Namespace.new('album', "http://albums.example.com")
    end
    
    it "should respond the namespace attribute" do
      @ns.namespace.should == :album
      @ns.uri.should == "http://albums.example.com"
    end

    it "should auto insert a method not found" do
      title = "Entry Song"
      @ns.title = title
      @ns.should be_include(:title)
      @ns.title.should == title
    end
    
    it "should raise error method if accessing something unavailable" do
      lambda {
        @ns.foobar
      }.should raise_error(NoMethodError,  "undefined method `foobar' for {}:#{@ns.class.to_s}")
    end
    
  end # context "create"
end