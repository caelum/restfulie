require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::Cache::Restrictions do

  it "should not cache DELETE, PUT, TRACE, HEAD, OPTIONS" do
    mocked = Object.new
    mocked.should_receive(:kind_of?).and_return(false)
    mocked.should_receive(:kind_of?).and_return(false)
    Restfulie::Client::Cache::Restrictions.may_cache_method?(mocked).should be_false
  end

  it "should cache GET and POST" do
    mocked = Object.new
    mocked.should_receive(:kind_of?).with(Net::HTTP::Post).and_return(true)
    Restfulie::Client::Cache::Restrictions.may_cache_method?(mocked).should be_true

    mocked = Object.new
    mocked.should_receive(:kind_of?).with(Net::HTTP::Get).and_return(true)
    mocked.should_receive(:kind_of?).with(Net::HTTP::Post).and_return(false)
    Restfulie::Client::Cache::Restrictions.may_cache_method?(mocked).should be_true
  end
  
  it "should cache if has the Cache-Control and max-age header" do
    request = Object.new
    response = mock(Net::HTTPResponse)
    Restfulie::Client::Cache::Restrictions.should_receive(:may_cache_method?).with(request).and_return true
    response.should_receive(:may_cache?).and_return true
        
    Restfulie::Client::Cache::Restrictions.may_cache?(request, response).should be_true
  end
end
