require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

context Restfulie::Common::Builder::Rules::CustomAttributes do
  
  class AttributedType
    include Restfulie::Common::Builder::Rules::CustomAttributes
  end
  context "create" do
    before do 
      @att = AttributedType.new
    end
    
    it "should respond to inserted values" do
      title = "Entry Song"
      @att.title = title
      @att.should respond_to(:title)
      @att.title.should == title
    end
    
    it "should raise an error if accessing something unavailable" do
      lambda {
        @att.foobar
      }.should raise_error(NoMethodError)
    end
    
  end # context "create"
end