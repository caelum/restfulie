require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie::Client::Cache::Fake do
  
  it "should always retrieve nil, even if it was put" do
    req = Object.new
    url = Object.new
    response = mock Net::HTTPResponse
    cache = Restfulie::Client::Cache::Fake.new
    cache.put(url, req, response)
    cache.get(url, req).should be_nil
  end
  
  it "putting should return the response" do
    req = Object.new
    url = Object.new
    response = mock Net::HTTPResponse
    cache = Restfulie::Client::Cache::Fake.new
    cache.put(url, req, response).should == response
  end
  
end

context Restfulie::Client::Cache::Basic do
  it "should put on the cache if Cache-Control is enabled" do
    url = Object.new
    request = Object.new
    response = mock Net::HTTPResponse
    cache = Restfulie::Client::Cache::Basic.new
    response.should_receive(:vary_headers_for).with(request).and_return(1)
    response.should_receive(:vary_headers_for).with(request).and_return(1)
    
    Restfulie::Client::Cache::Restrictions.should_receive(:may_cache?).with(request, response).and_return(true)
    
    cache.put(url, request, response)
    response.should_receive(:has_expired_cache?).and_return(false)
    cache.get(url, request).should == response
  end

  it "should respect the vary header" do
    url = Object.new
    request = Object.new
    response = mock Net::HTTPResponse
    cache = Restfulie::Client::Cache::Basic.new
    response.should_receive(:vary_headers_for).with(request).and_return(1)
    response.should_receive(:vary_headers_for).with(request).and_return(2)
    
    Restfulie::Client::Cache::Restrictions.should_receive(:may_cache?).with(request, response).and_return(true)
    
    cache.put(url, request, response)
    cache.get(url, request).should be_nil
  end

  it "should not put on the cache if Cache-Control is enabled" do
    url = Object.new
    request = Object.new
    response = mock Net::HTTPResponse
    cache = Restfulie::Client::Cache::Basic.new
    
    Restfulie::Client::Cache::Restrictions.should_receive(:may_cache?).with(request, response).and_return(false)
    
    cache.put(url, request, response)
    cache.get(url, request).should be_nil
  end

  it "should remove from cache if expired" do
    url = Object.new
    request = Object.new
    response = mock Net::HTTPResponse
    cache = Restfulie::Client::Cache::Basic.new
    response.should_receive(:vary_headers_for).with(request).and_return(1)
    response.should_receive(:vary_headers_for).with(request).and_return(1)
    
    Restfulie::Client::Cache::Restrictions.should_receive(:may_cache?).with(request, response).and_return(true)
    
    cache.put(url, request, response)
    response.should_receive(:has_expired_cache?).and_return(true)
    cache.get(url, request).should be_nil
  end

  it "should allow cache clean up" do
    url = Object.new
    request = Object.new
    response = mock Net::HTTPResponse
    cache = Restfulie::Client::Cache::Basic.new
    
    Restfulie::Client::Cache::Restrictions.should_receive(:may_cache?).with(request, response).and_return(true)
    
    cache.put(url, request, response)
    cache.clear
    cache.get(url, request).should be_nil
  end

end

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