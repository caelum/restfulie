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