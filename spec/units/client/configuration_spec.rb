require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Restfulie::Client::Configuration::Test
  class AtomRepresentation; end
  class XmlRepresentation; end
end

context Restfulie::Client::Configuration do

  let(:configuration) { Restfulie::Client::Configuration.new }

  it "should be development as default environment" do
    configuration.environment.should equal :development    
  end
  
  it "should be a empty string as default entry point" do
    configuration.entry_point.should eql ''
  end

  it "should be a empty hash as default representations" do
    configuration.representations.should == {}
  end
  
  it "should allow to set the test environment" do
    configuration.environment = :test
    configuration.environment.should equal :test
  end
  
  it "should set the atom representations" do
    configuration.representations['application/atom+xml'] = Restfulie::Client::Configuration::Test::AtomRepresentation
    configuration.representations['application/atom+xml'].should == Restfulie::Client::Configuration::Test::AtomRepresentation
  end
  
  it "should allow a xml representation" do
    configuration.representations['application/xml'] = Restfulie::Client::Configuration::Test::XmlRepresentation
    configuration.representations['application/xml'].should == Restfulie::Client::Configuration::Test::XmlRepresentation    
  end
  
  it 'should allow change values for many environments' do
    configuration.entry_point = "http://foo.com/bar"
    configuration.entry_point.should == 'http://foo.com/bar'
        
    configuration.representations['application/atom+xml'] = Restfulie::Client::Configuration::Test::AtomRepresentation
    
    configuration.environment = :test
    
    configuration.entry_point.should be_empty
    configuration.representations.should be_empty
    
    configuration.entry_point = "http://bar.com/foo"
    
    configuration.representations['application/xml'] = Restfulie::Client::Configuration::Test::XmlRepresentation
    
    configuration.environment = :development
    configuration.entry_point.should == 'http://foo.com/bar'
    configuration.representations['application/atom+xml'].should == Restfulie::Client::Configuration::Test::AtomRepresentation
    
    configuration.environment = :test
    configuration.entry_point.should == 'http://bar.com/foo'
    configuration.representations['application/xml'].should == Restfulie::Client::Configuration::Test::XmlRepresentation
  end

end

