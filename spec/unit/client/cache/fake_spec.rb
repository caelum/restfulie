require 'spec_helper'

describe Restfulie::Client::Cache::Fake do
  
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

