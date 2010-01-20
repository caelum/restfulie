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

describe Restfulie::Server::Transition do
  
  class Payment
    attr_accessor :status
  end
  
  context "when executing a transition" do
    it "should change its status if there is a resulting status to move to, always setting a string" do
      
      [:paid, "paid"].each do |result|
        order = Payment.new
        order.status = "unpaid"
      
        pay = Restfulie::Server::Transition.new(:pay, {}, result, nil)
        pay.execute_at order
        order.status.should == "paid"
      end

    end
    it "should bit change its status if there is a resulting status to move to" do
      
      order = Payment.new
      order.status = "unpaid"
    
      pay = Restfulie::Server::Transition.new(:pay, {}, nil, nil)
      pay.execute_at order
      order.status.should == "unpaid"

    end
  end
  
end