require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Builder::Base do
  context "load marshallings" do
    before do
      @builder = Restfulie::Builder::Base.new
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
      lambda {
        @builder.to_bar()
      }.should raise_error(NoMethodError, "undefined method `to_bar' for #{@builder}")
    end
  end # context "load marshallings"
end