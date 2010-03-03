require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context ::Restfulie::Marshalling do
  
  context "load marshallings" do
    it "should be respond by method_missing" do
      ::Restfulie::Marshalling.should respond_to(:method_missing)
    end

    it "should fail to call marshallings unsupported" do
      ::Restfulie::Marshalling.should_not respond_to(:to_foobar)
    end
  
    it "should not replace native to methods" do
      ::Restfulie::Marshalling.should_not respond_to(:to_s)
    end
  
    context "adicional marshallings" do
      it "should have a attribute marshallings_path and attribute should array" do
        ::Restfulie::Marshalling.should respond_to(:marshallings_path)
        ::Restfulie::Marshalling.marshallings_path.should be_kind_of(Array)
      end

      it "should verify the existence of marshallings in the paths" do
        ::Restfulie::Marshalling.marshallings_path << File.expand_path(File.dirname(__FILE__) + '/../../lib/marshallings')
        ::Restfulie::Marshalling.should respond_to(:to_bar)
      end
    end # context "adicional marshallings"
  
    context "load marshallings" do
      before(:all) do
        ::Restfulie::Marshalling.send(:remove_const, :Foo) if ::Restfulie::Marshalling.const_defined?(:Foo)
        ::Restfulie::Marshalling.marshallings_path << File.expand_path(File.dirname(__FILE__) + '/../../lib/marshallings')
      end
    
      it "should autoload the marshallings" do
        ::Restfulie::Marshalling.to_foo([])
        ::Restfulie::Marshalling.should be_const_defined(:Foo)
      end

      it "should allow manual loading of marshalling" do
        ::Restfulie::Marshalling.load_marshalling(:foo)
        ::Restfulie::Marshalling.should be_const_defined(:Foo)
      end
    
    end # context "load marshallings"
  
    # it "should raiser error for a marshalling not found" do
    #   msg = "Marshalling Bar not fould."
    #   lambda {
    #     ::Restfulie::Marshalling.load_marshalling(:bar)
    #   }.should raise_error(::Restfulie::Error::UndefinedMarshallingError, msg)
    # end
  end # context "load marshallings"
  
  # context "marshalling objects" do
  #   
  #   it "" do
  #     ::Restfulie::Marshalling.entry(Object.new) do |entry|
  #       entry.title = "Object test"
  #     end
  #     
  #     entry.should kind_of(Marshalling)
  #   end
  #   
  # end # context "marshalling objects"
  
end # context ::Restfulie::Marshalling
