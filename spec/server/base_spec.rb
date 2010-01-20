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
  acts_as_restfulie
end

context Restfulie::Server::Base do
  
  context "when creating a transition" do
    class Account
      acts_as_restfulie
    end
    class AccountsController
    end
    it "should not add a pay method if it doesnt exist" do
      Account.transition :pay
      AccountsController.should_not respond_to(:pay)
    end
  end
  
  context "when acting as restfulie" do
    it "should import module MimeType" do
      class City
        acts_as_restfulie
      end
      City.should be_kind_of(Restfulie::MediaTypeControl)
    end
  end
  
end