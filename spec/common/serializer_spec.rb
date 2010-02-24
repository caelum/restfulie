require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context ::Restfulie::Serializer do
  it "should be respond by method_missing" do
    ::Restfulie::Serializer.should respond_to(:method_missing)
  end

  it "should fail to call serializers unsupported" do
    ::Restfulie::Serializer.should_not respond_to(:to_foobar)
  end
  
  it "should not replace native to methods" do
    ::Restfulie::Serializer.should_not respond_to(:to_s)
  end
  
  context "adicional serializers" do
    it "should have a attribute serializers_path and attribute should array" do
      ::Restfulie::Serializer.should respond_to(:serializers_path)
      ::Restfulie::Serializer.serializers_path.should be_kind_of(Array)
    end

    it "should verify the existence of serializers in the paths" do
      ::Restfulie::Serializer.serializers_path << File.expand_path(File.dirname(__FILE__) + '/../lib/serializers')
      ::Restfulie::Serializer.should respond_to(:to_bar)
    end
  end # context "adicional serializers"
  
  context "load serializers" do
    before(:all) do
      ::Restfulie::Serializer.send(:remove_const, :Foo) if ::Restfulie::Serializer.const_defined?(:Foo)
      ::Restfulie::Serializer.serializers_path << File.expand_path(File.dirname(__FILE__) + '/../lib/serializers')
    end
    
    it "should autoload the serializers" do
      ::Restfulie::Serializer.to_foo([])
      ::Restfulie::Serializer.should be_const_defined(:Foo)
    end

    it "should allow manual loading of serializer" do
      ::Restfulie::Serializer.load_serializer(:foo)
      ::Restfulie::Serializer.should be_const_defined(:Foo)
    end
    
  end # context "load serializers"
  
  it "should raiser error for a serializer not found" do
    msg = "Serializer Bar not fould."
    lambda {
      ::Restfulie::Serializer.load_serializer(:bar)
    }.should raise_error(::Restfulie::Error::UndefinedSerializerError, msg)
  end

end # context ::Restfulie::Serializer
