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

module Restfulie
  module OpenSearch
    
    class Description
      
      def self.define(attribute, xml_attribute)
        
        define_method("#{attribute.to_s}=") do |new_value|
          self.instance_variable_set(xml_attribute, new_value)
        end
        
        define_method(attribute.to_s) do |new_value|
          self.instance_variable_get xml_attribute
        end
        
      end
      
      define(:short_name, :@ShortName)
      define(:description, :@Description)
      define(:tags, :@Tags)
      define(:contact, :@Contact)
      
      def initialize(name)
        short_name = name
        description = name
        @types = []
      end
      
      def accepts(content_type)
        @types << content_type
        self
      end
      
    end
    
  end
end