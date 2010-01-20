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

class CustomType < ActiveRecord::Base
  uses_restfulie
end
class Item
end

context Restfulie::Client::Config do

  context "while checking for GET verbs that extract info" do

    it "should be self refreshers only in self retrieval" do
      Restfulie::Client::Config.self_retrieval.each do |key|
        CustomType.is_self_retrieval?(key).should be_true
      end
    end

    it "should be self refreshers only in self retrieval, but also strings" do
      Restfulie::Client::Config.self_retrieval.each do |key|
        CustomType.is_self_retrieval?(key.to_s).should be_true
      end
    end

  end
  
  context "when deciding which http method to use" do
    
    it "should use overriden values if available" do
      [:delete, :put, :get, :post].each do |option|
        Restfulie::Client::Config.requisition_method_for(option, nil).should == "Net::HTTP::#{option.to_s.camelcase}".constantize
      end
    end

    it "should use default delete values" do
      [:destroy, :delete, :cancel].each do |option|
        Restfulie::Client::Config.requisition_method_for(nil, option).should == Net::HTTP::Delete
      end
    end

    it "should use overriden values if available" do
      [:refresh, :reload, :show, :latest, :self].each do |option|
        Restfulie::Client::Config.requisition_method_for(nil, option).should == Net::HTTP::Get
      end
    end
  end
  
end
