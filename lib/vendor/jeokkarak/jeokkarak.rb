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

require 'vendor/jeokkarak/hashi'
 
module Jeokkarak
  module Base
    
    # defines that this type has a child element
    def has_child(type, options={})
      resource_children[options[:as]] = type
    end
    
    # checks what is the type element for this type (supports rails ActiveRecord, has_child and Hashi)
    def child_type_for(name)
      return reflect_on_association(name.to_sym ).klass if respond_to? :reflect_on_association
      resource_children[name] || Hashi
    end
    
    # returns the registered children list for this resource
    def resource_children
      @children ||= {}
      @children
    end
    
    # creates an instance of this type based on this hash
    def from_hash(h)
      h = {} if h.nil? # nasty required check
      h = h.dup
      result = self.new
      result._internal_hash = h
      h.each do |key,value|
        from_hash_parse result, h, key, value
      end
      def result.method_missing(name, *args, &block)
        Hashi.to_object(@_internal_hash).send(name, args[0], block)
      end
      result
    end
    
    # extension point to parse a value
    def from_hash_parse(result,h,key,value)
      case value.class.to_s
      when 'Array'
        h[key].map! { |e| child_type_for(key).from_hash e }
      when /\AHash(WithIndifferentAccess)?\Z/
        h[key] = child_type_for(key ).from_hash value
      end
      name = "#{key}="
      result.send(name, value) if result.respond_to?(name)
    end
  end
end
 
module Jeokkarak
  module Config
    
    # entry point to define a jeokkarak type
    def acts_as_jeokkarak
      self.module_eval do
        attr_accessor :_internal_hash
      end
      self.extend Jeokkarak::Base
    end
  end
end
 
Object.extend Jeokkarak::Config
