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

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::HTTPResponse do
  
  def check_complies_with(from, to, method)
    o = Hashi::CustomHash.new
    o.extend Restfulie::Client::HTTPResponse
    (from..to).each do |code|
      o.code = code
      o.send(method).should be_true
    end
    [from-1,to+1].each do |code|
      o.code = code
      o.send(method).should be_false
    end
  end
  
  it "should return successful for 200~299" do
    check_complies_with(200, 299, :is_successful?)
  end

  it "should return informational for 100~199" do
    check_complies_with(100, 199, :is_informational?)
  end

  it "should return redirection for 300~399" do
    check_complies_with(300, 399, :is_redirection?)
  end

  it "should return redirection for 400~499" do
    check_complies_with(400, 499, :is_client_error?)
  end

  it "should return redirection for 500~599" do
    check_complies_with(500, 599, :is_server_error?)
  end

end

context Restfulie::Client::HTTPResponse do
  
  before do
    @response = mock Net::HTTPResponse
    @response.extend Restfulie::Client::HTTPResponse
  end

  context "while retrieveing cache information" do
    
    it "should invoke may_ache_field with cachec ontrol" do
      response = Object.new
      controls = [:cache_headers]
      @response.should_receive(:get_fields).with('Cache-control').and_return(controls)
      @response.should_receive(:may_cache_field?).with(controls).and_return(response)
      @response.may_cache?.should == response
    end
    
    it "should not cache if Cache-Control is not available" do
      @response.may_cache_field?(nil).should be_false
    end

    it "should not cache if Cache-Control's max-age is not available" do
      @response.may_cache_field?('s-maxage=100000').should be_false
    end

    it "should cache if finds max-age" do
      @response.may_cache_field?('max-age=100000, please-store').should be_true
    end
  
    it "should not cache if Cache-Control's no-store is set" do
      @response.may_cache_field?('max-age=100000, no-store').should be_false
    end
  
    it "should use all headers if received more than one header" do
      @response.may_cache_field?(['max-age=100000', 'no-store']).should be_false
    end
  
    it "should extract max-age from start" do
      @response.value_for('max-age=100', /^max-age=(\d+)/).should == "max-age=100"
    end
  
    it "should extract max-age from the middle" do
      @response.value_for('a=b,max-age=100', /^max-age=(\d+)/).should == "max-age=100"
    end
  
    it "should extract max-age from the middle even with whitespace" do
      @response.value_for('a=b, max-age=100', /^max-age=(\d+)/).should == " max-age=100"
    end
  
    it "should return nil if not found" do
      @response.value_for('a=b,s-max-age=100', /^max-age=(\d+)/).should be_nil
    end
  end
  
  context "when retrieving caching values" do
    
    it "should return 0 if the header value is not present" do
      @response.should_receive(:header_value_from).with('Cache-control', /^\s*max-age=(\d+)/).and_return(nil)
      @response.cache_max_age.should == 0
    end
    
    it "should return the parsed value if the header value is not present" do
      @response.should_receive(:header_value_from).with('Cache-control', /^\s*max-age=(\d+)/).and_return("57")
      @response.cache_max_age.should == 57
    end
    
    it "should return nothing if the header is not there" do
      field = Object.new
      @response.should_receive(:get_fields).with('header').and_return([field])
      @response.should_receive(:value_for).with(field, 'expression').and_return(nil)
      @response.header_value_from('header','expression').should be_nil
    end
    
    it "should return the matching expression when extracting the header value" do
      field = Object.new
      @response.should_receive(:get_fields).with('header').and_return([field])
      @response.should_receive(:value_for).with(field, /as(df)/).and_return("asdf")
      @response.header_value_from('header', /as(df)/).should == "df"
    end
    
  end
  
  class HeaderMock
    def initialize(entity)
      @entity=entity
    end
    def []=(key, value)
      @entity.stub(:[]).with(key).and_return(value)
    end
  end
  
  def headers(entity)
    HeaderMock.new(entity)
  end

  context "when retrieving caching values" do
    it "should expire the response if there is no date" do
      headers(@response)['Date'] = nil
      @response.should be_has_expired_cache
    end

    it "should expire the response if its in the past with" do
      Time.should_receive(:now).and_return(201)
      Time.should_receive(:rfc2822).and_return(100)
      @response.should_receive(:cache_max_age).and_return(100)
      headers(@response)['Date'] = Object.new
      @response.has_expired_cache?.should be_true
    end

    it "should expire the response if its in the past with" do
      Time.should_receive(:now).and_return(199)
      Time.should_receive(:rfc2822).and_return(100)
      @response.should_receive(:cache_max_age).and_return(100)
      headers(@response)['Date'] = Object.new
      @response.has_expired_cache?.should be_false
    end

  end

  context "when checking response variants" do
    
    before do
      @request = mock Net::HTTPResponse
      @request.extend Restfulie::Client::HTTPResponse
    end
    
    it "should answer with the from the request matching Vary header" do
      headers(@response)['Vary'] = 'Accept'
      headers(@request)['Accept'] = 'application/xml'
      @response.vary_headers_for(@request).should == ['application/xml']
    end
    
  end

end