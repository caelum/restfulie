require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context ::Restfulie::Builder::Marshalling do
  
  it "should register a new path for marshalling classes" do
    ::Restfulie::Builder::Marshalling.add_autoload_path(File.expand_path(File.dirname(__FILE__) + '/../../lib/marshalling')).should be_true
    lambda {
      ::Restfulie::Builder::Marshalling.add_autoload_path('./example.com')
    }.should raise_error(::Restfulie::Error::MarshallingError, "./example.com is not a path.")
  end
  
  context "autoload" do
    before do
      ::Restfulie::Builder::Marshalling.send(:remove_const, :Foo) if ::Restfulie::Builder::Marshalling.const_defined?(:Foo)
    end
    
    it "should register to autoload marshalling given a path" do
      ::Restfulie::Builder::Marshalling.autoload?(:Foo).should be_nil
      ::Restfulie::Builder::Marshalling.add_autoload_path(File.expand_path(File.dirname(__FILE__) + '/../../lib/marshalling'))
      ::Restfulie::Builder::Marshalling.autoload?(:Foo).should be_true
    end
    
    it "should do autoload marshalling class" do
      ::Restfulie::Builder::Marshalling.const_defined?(:Foo).should be_false
      ::Restfulie::Builder::Marshalling.add_autoload_path(File.expand_path(File.dirname(__FILE__) + '/../../lib/marshalling'))
      ::Restfulie::Builder::Marshalling.const_defined?(:Foo).should be_true
      ::Restfulie::Builder::Marshalling::Foo.new().should_not be_nil
    end
  end # context "autoload"
  
end # context ::Restfulie::Marshalling
