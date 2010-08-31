require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::Cache::Restrictions do

  it "should not cache DELETE, PUT, TRACE, HEAD, OPTIONS" do
    [:delete, :put, :trace, :head, :options, :patch].each do |verb|
      Restfulie::Client::Cache::Restrictions.may_cache_method?(verb).should be_false
    end
  end

  it "should cache GET and POST" do
    Restfulie::Client::Cache::Restrictions.may_cache_method?(:post).should be_true
    Restfulie::Client::Cache::Restrictions.may_cache_method?(:get).should be_true
  end
  
  it "should cache if the response may be cached" do
    request = Object.new
    response = mock(Net::HTTPResponse)
    Restfulie::Client::Cache::Restrictions.should_receive(:may_cache_method?).with(:get).and_return true
    response.should_receive(:may_cache?).and_return true
    response.should_receive(:method).and_return :get
        
    Restfulie::Client::Cache::Restrictions.may_cache?(response).should be_true
  end
end
