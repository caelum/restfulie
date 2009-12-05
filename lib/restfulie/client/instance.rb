module Restfulie
  module Client
    module Instance
      
      # list of possible states to access
      attr_accessor :_possible_states

      # which content-type generated this data
      attr_accessor :_came_from
      
      def invoke_remote_transition(name, options, block)

        method = self.class.requisition_method_for options[:method], name

        state = _possible_states[name]
        url = URI.parse(state["href"] || state[:href])
        req = method.new(url.path)
        req.body = options[:data] if options[:data]
        req.add_field("Accept", "application/xml") if self._came_from == :xml

        response = Net::HTTP.new(url.host, url.port).request(req)

        return block.call(response) if block
        return response if method != Net::HTTP::Get
        self.class.from_response response
      end

  
      # inserts all transitions from this object as can_xxx and xxx methods
      def add_transitions(transitions)
        self._possible_states = {}

        transitions.each do |state|
          self._possible_states[state["rel"] || state[:rel]] = state
          self.add_state(state)
        end
        self.extend Restfulie::Server::State
      end

    
      def add_state(transition)
        name = transition["rel"] || transition[:rel]
      
        # TODO: wrong, should be instance_eval
        puts "i will define a method #{name} now!"
        self.class.module_eval do
        
          def temp_method(options = {}, &block)
            self.invoke_remote_transition(Restfulie::Client::Helper.current_method, options, block)
          end
        
          alias_method name, :temp_method
          undef :temp_method
        end
      end  


    end
  end
end
