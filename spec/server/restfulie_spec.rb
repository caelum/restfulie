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

require 'net/http'
require 'uri'
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class RestfulieModel < ActiveRecord::Base
  attr_accessor :content
end

class Order < ActiveRecord::Base
  attr_accessor :buyer
end

class MockedController
  def url_for(x)
    "http://url_for/#{x[:action]}"
  end
end

context RestfulieModel do

  before do
    subject.status = :unpaid
  end

  context "when checking the available transitions" do
    it "should return nothing if there is no status field" do
      class Client
        acts_as_restfulie
      end
      c = Client.new
      c.available_transitions.should == {:allow=>[]}
    end
    it "should return nothing if there is status field is nil" do
      class Client
        acts_as_restfulie
        def status
          nil
        end
      end
      c = Client.new
      c.available_transitions.should == {:allow=>[]}
    end
  end
  
  context "when checking permissions" do
    it "should add can_xxx methods allowing one to check whther the transition is valid or not" do
        my_controller = MockedController.new
        RestfulieModel.acts_as_restfulie
        RestfulieModel.transition :pay, {}
        RestfulieModel.state :unpaid, :allow => :pay
        RestfulieModel.state :paid
        
        subject.status = :unpaid
        subject.can_pay?.should == true
  
        subject.status = :paid
        subject.can_pay?.should == false
        
    end
  end
  
  context "when invoking acts_as_restfulie" do
    class CustomAccount
    end
    it "should add all methods from Restfulie::Base to the target class" do
        CustomAccount.acts_as_restfulie
        Restfulie::Server::Base.methods.each do |m|
          CustomAccount.methods.include? m
        end
    end
  end
end
