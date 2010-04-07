require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context ::Restfulie::Common::Builder::Marshalling do
  
  it "should register a new path for marshalling classes" do
    ::Restfulie::Common::Builder::Marshalling.add_autoload_path(File.expand_path(File.dirname(__FILE__) + '/../../lib/marshalling')).should be_true
    lambda {
      ::Restfulie::Common::Builder::Marshalling.add_autoload_path('./example.com')
    }.should raise_error(::Restfulie::Common::Error::MarshallingError, "./example.com is not a path.")
  end
  
  context "autoload" do
    before do
      ::Restfulie::Common::Builder::Marshalling.send(:remove_const, :Foo) if ::Restfulie::Common::Builder::Marshalling.const_defined?(:Foo)
    end
    
    it "should register to autoload marshalling given a path" do
      ::Restfulie::Common::Builder::Marshalling.autoload?(:Foo).should be_nil
      ::Restfulie::Common::Builder::Marshalling.add_autoload_path(File.expand_path(File.dirname(__FILE__) + '/../../lib/marshalling'))
      ::Restfulie::Common::Builder::Marshalling.autoload?(:Foo).should be_true
    end
    
    it "should do autoload marshalling class" do
      ::Restfulie::Common::Builder::Marshalling.const_defined?(:Foo).should be_false
      ::Restfulie::Common::Builder::Marshalling.add_autoload_path(File.expand_path(File.dirname(__FILE__) + '/../../lib/marshalling'))
      ::Restfulie::Common::Builder::Marshalling.const_defined?(:Foo).should be_true
      ::Restfulie::Common::Builder::Marshalling::Foo.new().should_not be_nil
    end
  end # context "autoload"
  
end # context ::Restfulie::Marshalling
