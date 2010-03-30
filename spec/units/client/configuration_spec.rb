require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Restfulie::Client::Configuration::Test
  class AtomRepresentation; end
  class XmlRepresentation; end
end

context Restfulie::Client::Configuration do

  before(:each) do
    @configuration = Restfulie::Client::Configuration.new
  end

  it 'should have default values' do
    @configuration.environment.should == :development
    @configuration.entry_point.should be_empty
    @configuration.representations.should be_empty
  end

  it 'should allow change values for many environments' do
    @configuration.environment.should == :development
    @configuration.entry_point.should be_empty
    @configuration.representations.should be_empty

    @configuration.entry_point = "http://foo.com/bar"
    @configuration.entry_point.should == 'http://foo.com/bar'

    @configuration.representations['application/atom+xml'] = Restfulie::Client::Configuration::Test::AtomRepresentation
    @configuration.representations['application/atom+xml'].should == Restfulie::Client::Configuration::Test::AtomRepresentation

    @configuration.environment = :test

    @configuration.environment.should == :test
    @configuration.entry_point.should be_empty
    @configuration.representations.should be_empty

    @configuration.entry_point = "http://bar.com/foo"
    @configuration.entry_point.should == 'http://bar.com/foo'

    @configuration.representations['application/xml'] = Restfulie::Client::Configuration::Test::XmlRepresentation
    @configuration.representations['application/xml'].should == Restfulie::Client::Configuration::Test::XmlRepresentation

    @configuration.environment = :development
    @configuration.entry_point.should == 'http://foo.com/bar'
    @configuration.representations['application/atom+xml'].should == Restfulie::Client::Configuration::Test::AtomRepresentation

    @configuration.environment = :test
    @configuration.entry_point.should == 'http://bar.com/foo'
    @configuration.representations['application/xml'].should == Restfulie::Client::Configuration::Test::XmlRepresentation
  end

end

