require File.join(File.dirname(__FILE__),'..','spec_helper')

context Restfulie::Client::Configuration do

  before(:each) do
    @configuration = Restfulie::Client::Configuration.new
  end

  it 'should have default values' do
    @configuration.environment.should == :development
    @configuration.default_headers[:get]['Accept'].should == 'application/atom+xml'
    @configuration.default_headers[:post]['Content-Type'].should == 'application/atom+xml'
    @configuration.entry_point.should be_empty
    @configuration.auto_follows.should be_empty
    @configuration[:entry_point].should be_empty
  end

  it 'should allow change values' do
    @configuration.default_headers[:get]['Accept'].should == 'application/atom+xml'
    @configuration.default_headers[:post]['Content-Type'].should == 'application/atom+xml'
    @configuration.default_headers = {
      :get  => { 'Accept' => 'application/xml' },
      :post => { 'Content-Type' => 'text/html' }
    }
    @configuration.default_headers[:get]['Accept'].should == 'application/xml'
    @configuration.default_headers[:post]['Content-Type'].should == 'text/html'

    @configuration.entry_point.should be_empty
    @configuration.entry_point = "http://foo.com/bar"
    @configuration.entry_point.should == 'http://foo.com/bar'

    @configuration.auto_follows.should be_empty
    @configuration.auto_follows = { 301 => [:post,:put,:delete] }
    @configuration.auto_follows[301].first.should == :post

    @configuration[:entry_point].should == 'http://foo.com/bar'
  end

  it 'should have configurations for many environments' do
    @configuration.environment.should == :development
    @configuration.default_headers[:get]['Accept'].should == 'application/atom+xml'
    @configuration.default_headers[:post]['Content-Type'].should == 'application/atom+xml'
    @configuration.default_headers = {
      :get  => { 'Accept' => 'application/xml' },
      :post => { 'Content-Type' => 'text/html' }
    }
    @configuration.default_headers[:get]['Accept'].should == 'application/xml'
    @configuration.default_headers[:post]['Content-Type'].should == 'text/html'
   
    @configuration.environment = :test
    @configuration.environment.should == :test
    @configuration.default_headers[:get]['Accept'].should == 'application/atom+xml'
    @configuration.default_headers[:post]['Content-Type'].should == 'application/atom+xml'

    @configuration.environment = :development
    @configuration.environment.should == :development
    @configuration.default_headers[:get]['Accept'].should == 'application/xml'
    @configuration.default_headers[:post]['Content-Type'].should == 'text/html'
  end

end

