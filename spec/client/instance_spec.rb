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

context Restfulie::Client::InstanceMethods do
  
  context "when parsing a transition execution" do
    
    before do
      @o = Object.new
      @o.extend Restfulie::Client::InstanceMethods
    end
    
    it "should leave data as nil and options as hash if there is no arg" do
      data, options = @o.parse_args_from_transition([])
      data.should be_nil
      options.should be_empty
    end

    it "should leave data as it was and options as new hash if there is an option" do
      data, options = @o.parse_args_from_transition([123])
      data.should == 123
      options.should be_empty
    end

    it "should leave data as it was options as its hash if there are both args" do
      hash = { :name => :value }
      data, options = @o.parse_args_from_transition([123, hash])
      data.should == 123
      options.should == hash
    end

    it "should create data as nil and options as it was if there is only a hash" do
      hash = { :name => :value }
      data, options = @o.parse_args_from_transition([hash])
      data.should be_nil
      options.should == hash
    end

  end

end
