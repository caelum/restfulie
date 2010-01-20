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
  
  module Server

    # represents a transition on the server side
    class Transition
      attr_reader :body, :name
      attr_writer :options
      attr_accessor :result
      
      def initialize(*args)
        args[0].kind_of?(Array) ? from_array(*args) : from(*args)
      end
      
      private
      def from_array(array)
        @name = array[0]
        @options = array.length>0 ? array[1] : nil
        @result = array.length>1 ? array[2] : nil
        @body = nil
      end
      
      def from(name, options = {}, result = nil, body = nil)
        @name = name
        @options = options
        @result = result
        @body = body
      end
      
      public
      
      def action
        @options || {}
      end
      
      # executes this transition in a resource
      def execute_at(target_object)
        target_object.status = @result.to_s unless @result.nil?
      end
    
      # return the link to this transitions's uri
      def link_for(model, controller)
        specific_action = @body ? @body.call(model) : action.dup

        specific_action = parse_specific_action(specific_action, model)

        rel = specific_action[:rel] || @name
        specific_action[:rel] = nil

        specific_action[:action] ||= @name
        uri = controller.url_for(specific_action)
        
        return rel, uri
      end
      
      private

      # if you use the class level DSL, you will need to add a lambda for instance level accessors:
      #   transition :show, {:action => :show, :foo_id => lambda { |model| model.id }}
      # but you can replace it for a symbol and defer the model call
      #   transition :show, {:action => :show, :foo_id => :id}
      def parse_specific_action(action, model)
        action.inject({}) do |actions, pair|
          if pair.last.is_a?( Symbol ) && model.attributes.include?(pair.last)
            actions.merge!( pair.first => model.send(pair.last) )
          else
            actions.merge!( pair.first => pair.last )
          end
        end
        action
      end
      
    end
  end

end
