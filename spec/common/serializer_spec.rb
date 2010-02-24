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

  context "serializers_path" do

    it "should have a attribute and attribute should array" do
      ::Restfulie::Serializer.should respond_to(:serializers_path)
      ::Restfulie::Serializer.serializers_path.should be_kind_of(Array)
    end

    it "should verify the existence of serializers in the paths" do
      ::Restfulie::Serializer.should_not respond_to(:to_bar)
      ::Restfulie::Serializer.serializers_path << File.expand_path(File.dirname(__FILE__) + '/../lib/serializers')
      ::Restfulie::Serializer.should respond_to(:to_bar)
    end

  end # context "serializers_path"

  it "should autoload the serializers" do
    ::Restfulie::Serializer.send(:remove_const, :Foo) if ::Restfulie::Serializer.const_defined?(:Foo)
    ::Restfulie::Serializer.serializers_path << File.expand_path(File.dirname(__FILE__) + '/../lib/serializers')
    ::Restfulie::Serializer.to_foo([])
    ::Restfulie::Serializer.should be_const_defined(:Foo)
  end
  
  it "should raiser error for a serializer not found" do
    msg = "Serializer Bar not fould."
    lambda {
      ::Restfulie::Serializer.to_bar([])
    }.should raise_error(::Restfulie::Error::UndefinedSerializerError, msg)
  end
  
  it "should return Atom object to call to_atom" do
    ::Restfulie::Serializer.to_atom([]).should be_kind_of(::Restfulie::Serializer::Atom)
  end

end # context ::Restfulie::Serializer
