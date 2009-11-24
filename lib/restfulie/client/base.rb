module Restfulie
  module Client
    module Base 
    
      # translates a response to an object
      def from_response(res)
      
        raise "unimplemented content type" if res.content_type!="application/xml"

        hash = Hash.from_xml res.body
        return hash if hash.keys.length == 0
        raise "unable to parse an xml with more than one root element" if hash.keys.length>1
      
        type = hash.keys[0].camelize.constantize
        type.from_xml(res.body)
      
      end
    
      def requisition_method_for(overriden_option,name)
        basic_mapping = { :delete => Net::HTTP::Delete, :put => Net::HTTP::Put, :get => Net::HTTP::Get, :post => Net::HTTP::Post}
        defaults = {:destroy => Net::HTTP::Delete, :delete => Net::HTTP::Delete, :cancel => Net::HTTP::Delete,
                    :refresh => Net::HTTP::Get, :reload => Net::HTTP::Get, :show => Net::HTTP::Get, :latest => Net::HTTP::Get}

        return basic_mapping[overriden_option.to_sym] if overriden_option
        defaults[name.to_sym] || Net::HTTP::Post
      end
    
      def add_state(transition)
        name = transition["rel"]
      
        self.module_eval do
        
          def temp_method(options = {}, &block)
            self.invoke_remote_transition(Restfulie::Helper.current_method, options, block)
          end
        
          alias_method name, :temp_method
          undef :temp_method
        end
      end  
    
      # receives an object and inserts all necessary methods
      # so it can answer to can_??? invocations
      def add_states(result, states)
        result._possible_states = {}

        states.each do |state|
          result._possible_states[state["rel"]] = state
          add_state(state)
        end
        result.extend Restfulie::Server::State
      
        result
      end

      # retrieves a resource form a specific uri
      def from_web(uri)
        res = Net::HTTP.get_response(URI.parse(uri))
        # TODO redirect... follow or not? (optional...)
        raise "invalid request" if res.code != "200"
      
        # TODO really support different content types
        case res.content_type
        when "application/xml"
          self.from_xml res.body
        when "application/json"
          self.from_json res.body
        else
          raise "unknown content type"
        end
      
      end

    end
  end
end
