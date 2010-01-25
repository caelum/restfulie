#
#  Copyright (c) 2009 Caelum - www.caelum.com.br/opensource
#  All rights reserved.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); 
#  you may not use this file except in compliance with the License. 
#  You may obtain a copy of the License at 
#  
#   http://www.apache.org/licenses/LICENSE-2.0 
#  
#  Unless required by applicable law or agreed to in writing, software 
#  distributed under the License is distributed on an "AS IS" BASIS, 
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
#  See the License for the specific language governing permissions and 
#  limitations under the License. 
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie::FakeCache do
  
  it "should always retrieve nil, even if it was put" do
    req = Object.new
    url = Object.new
    response = mock Net::HTTPResponse
    cache = Restfulie::FakeCache.new
    cache.put(url, req, response)
    cache.get(url, req).should be_nil
  end
  
  it "putting should return the response" do
    req = Object.new
    url = Object.new
    response = mock Net::HTTPResponse
    cache = Restfulie::FakeCache.new
    cache.put(url, req, response).should == response
  end
  
end

context Restfulie::BasicCache do
  it "should put on the cache if Cache-Control is enabled" do
    url = Object.new
    request = Object.new
    response = mock Net::HTTPResponse
    cache = Restfulie::BasicCache.new
    
    Restfulie::Cache::Restrictions.should_receive(:may_cache).with(request, response).and_return(true)
    
    cache.put(url, request, response)
    cache.get(url, request).should == response
  end
end

context Restfulie::Cache::Restrictions do

  it "should not cache DELETE, PUT, TRACE, HEAD, OPTIONS" do
    ['Delete', 'Put', 'Trace', 'Head', 'Options'].each do |verb|
      Restfulie::Cache::Restrictions.may_cache_method("Net::HTTP::#{verb}".constantize).should be_false
    end
  end

  it "should cache GET and POST" do
    ['Get', 'Post'].each do |verb|
      Restfulie::Cache::Restrictions.may_cache_method("Net::HTTP::#{verb}".constantize).should be_true
    end
  end
  
  it "should not cache if Cache-Control is not available" do
    Restfulie::Cache::Restrictions.may_cache_cache_control(nil).should be_false
  end

  it "should not cache if Cache-Control's max-age is not available" do
    Restfulie::Cache::Restrictions.may_cache_cache_control('s-maxage=100000').should be_false
  end

  it "should cache if finds max-age" do
    Restfulie::Cache::Restrictions.may_cache_cache_control('max-age=100000, please-store').should be_true
  end
  
  it "should not cache if Cache-Control's no-store is set" do
    Restfulie::Cache::Restrictions.may_cache_cache_control('max-age=100000, no-store').should be_false
  end
  
  it "should use all headers if received more than one header" do
    Restfulie::Cache::Restrictions.may_cache_cache_control(['max-age=100000', 'no-store']).should be_false
  end
  
  it "should extract max-age from start" do
    Restfulie::Cache::Restrictions.value_for('max-age=100', /^max-age=(\d+)/).should == "max-age=100"
  end
  
  it "should extract max-age from the middle" do
    Restfulie::Cache::Restrictions.value_for('a=b,max-age=100', /^max-age=(\d+)/).should == "max-age=100"
  end
  
  it "should extract max-age from the middle even with whitespace" do
    Restfulie::Cache::Restrictions.value_for('a=b, max-age=100', /^max-age=(\d+)/).should == " max-age=100"
  end
  
  it "should return nil if not found" do
    Restfulie::Cache::Restrictions.value_for('a=b,s-max-age=100', /^max-age=(\d+)/).should be_nil
  end

  it "should cache if has the Cache-Control and max-age header" do
    headers = 'max-age=100000'

    request = Object.new
    response = mock(Net::HTTPResponse)
    Restfulie::Cache::Restrictions.should_receive(:may_cache_method).with(request).and_return true
    Restfulie::Cache::Restrictions.should_receive(:may_cache_cache_control).with(headers).and_return true
    response.should_receive(:get_fields).and_return headers
        
    Restfulie::Cache::Restrictions.may_cache(request, response).should be_true
  end
end