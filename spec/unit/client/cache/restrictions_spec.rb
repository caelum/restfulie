require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::Cache::Restrictions do

  it "should cache if the response may be cached" do
    request = Object.new
    response = mock(Net::HTTPResponse)
    response.should_receive(:may_cache?).and_return true
        
    Restfulie::Client::Cache::Restrictions.may_cache?(response).should be_true
  end

  it "should not cache if the response may not be cached" do
    request = Object.new
    response = mock(Net::HTTPResponse)
    response.should_receive(:may_cache?).and_return false
        
    Restfulie::Client::Cache::Restrictions.may_cache?(response).should be_false
  end

  it "should not cache for nil" do
    Restfulie::Client::Cache::Restrictions.may_cache?(nil).should be_false
  end
end
