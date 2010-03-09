require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Builder::Base do
  def create_builder(*args)
    Restfulie::Builder::Base.new(*args)
  end
  
  it "accept object in new instance" do
    object  = Object.new
    builder = create_builder(object)
    builder.object.should == object
  end
  
  it "should respond by rules" do
    rules   = [Restfulie::Builder::MemberRule.new, Restfulie::Builder::CollectionRule.new]
    builder = create_builder(Object.new, rules)
    builder.rules.should eql(rules)
  end
  
  context "load marshallings" do
    before do
      @builder = create_builder(Object.new)
    end
    
    it "should be respond by method_missing" do
      @builder.should respond_to(:method_missing)
    end

    it "should fail to call marshallings unsupported" do
      @builder.should_not respond_to(:to_foobar)
    end
    
    it "should not replace native to methods" do
      @builder.should respond_to(:to_s)
    end

    it "should raiser error for a marshalling not found" do
      ::Restfulie::Builder::Marshalling.add_autoload_path(File.expand_path(File.dirname(__FILE__) + '/../../lib/marshalling'))
      lambda {
        @builder.to_bar()
      }.should raise_error(Restfulie::Error::UndefinedMarshallingError, "Marshalling Bar not fould.")
    end
  end # context "load marshallings"
end