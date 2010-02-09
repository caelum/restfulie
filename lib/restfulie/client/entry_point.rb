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
  module Client
    class FollowConfig
      def initialize
        @entries = {
          :moved_permanently => [:get, :head]
        }
      end
      def method_missing(name, *args)
        return value_for(name) if name.to_s[-1,1] == "?"
        set_all_for name
      end
      
      private
      def set_all_for(name)
        @entries[name] = :all
      end
      def value_for(name)
        return @entries[name.to_s.chop.to_sym]
      end
    end
    
    class EntryPointControl
      
      def initialize(type)
        @type = type
        @entries = {}
      end
      
      def method_missing(name, *args)
        @entries[name] ||= EntryPoint.new
        @entries[name]
      end

    end
    
    class EntryPoint
      attr_accessor :uri
      def at(uri)
        @uri = uri
      end
    end
    
  end
end
