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
  
    # adds respond_to and has_state methods to resources
    module State
    
      # overrides the respond_to? method to check if this method is contained or was defined by a state
      def respond_to?(sym)
        has_state(sym.to_s) || super(sym)
      end

      # returns true if this resource has a state named name
      def has_state(name)
        !@existing_relations[name].nil?
      end
    end
  end
end
