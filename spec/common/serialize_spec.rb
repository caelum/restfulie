require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie::Serializer do
  it "should be respond by method_missing" do
    Restfulie::Serializer.should be_respond_to(:method_missing)
  end

  it "should autoload the serializers" do
    Restfulie::Serializer.remove_const(:Atom) if Restfulie::Serializer.const_defined?(:Atom)
    Restfulie::Serializer.to_atom([])
    Restfulie::Serializer.should be_const_defined(:Atom)
  end

  it "should raiser error for a serializer not found" do
    msg = "Serializer Foobar not fould."
    lambda {
      Restfulie::Serializer.to_foobar([])
    }.should raise_error(Restfulie::Error::UndefinedSerializerError, msg)
  end

  it "should return Atom object to call to_atom" do
    Restfulie::Serializer.to_atom([]).should be_kind_of(Restfulie::Serializer::Atom)
  end

end # context Restfulie::Serializer