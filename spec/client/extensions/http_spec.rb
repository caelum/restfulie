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

end