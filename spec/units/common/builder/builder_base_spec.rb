require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Common::Builder::Base do
  def create_builder(*args)
    Restfulie::Common::Builder::Base.new(*args)
  end
  
  context "create a builder" do
    it "accept object in new instance" do
      object  = Object.new
      builder = create_builder(object)
      builder.object.should == object
    end
  
    it "should respond by rules blocks" do
      rules   = [lambda {}, lambda {}]
      builder = create_builder(Object.new, rules)
      builder.rules_blocks.should eql(rules)
    end
    
    it "returned not implemented marshalling call to_base" do
      builder = create_builder(nil)
      builder.to_base(:default_rule => false).should == "Base Marshalling not implemented"
      builder = create_builder([])
      builder.to_base(:default_rule => false).should == "Base Marshalling not implemented"
    end
    
  end # context "create a builder"
  
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
    
    it "should raise error method is not implemented" do
      lambda {
        @builder.foobar
      }.should raise_error(NoMethodError,  "undefined method `foobar' for #{@builder}")
    end

    it "should raiser error for a marshalling not found" do
      ::Restfulie::Common::Builder::Marshalling.add_autoload_path(File.expand_path(File.dirname(__FILE__) + '/../../lib/marshalling'))
      lambda {
        @builder.to_bar()
      }.should raise_error(Restfulie::Common::Error::UndefinedMarshallingError, "Marshalling Bar not found.")
    end
  end # context "load marshallings"
end