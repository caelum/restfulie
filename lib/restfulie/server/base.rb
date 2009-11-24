module Restfulie
  module Server
    module Base
    
      # returns the definition for the transaction
      def existing_transitions(name)
        transitions[name]
      end
    
      # returns a hash of all possible transitions: Restfulie::Server::Transition
      def transitions
        @transitions ||= {}
      end

      # returns a hash of all possible states
      def states
        @states ||= {}
      end

      # adds a new state to the list of possible states
      def state(name, options = {})
        options[:allow] = [options[:allow]] unless options[:allow].kind_of? Array
        states[name] = options
      end

      # defines a new transition. the transition options works in the same way
      # that following_transition definition does.
      def transition(name, options = {}, result = nil, &body)
      
        transition = Restfulie::Server::Transition.new(name, options, result, body)
        transitions[name] = transition

        define_methods_for(self, name, result)
        controller_name = (self.name + "Controller")
      end
 
      def define_methods_for(type, name, result) 

        return nil if type.respond_to?(name)

        type.send(:define_method, name) do |*args|
          self.status = result.to_s unless result == nil
        end

        type.send(:define_method, "can_#{name}?") do
          transitions = available_transitions[:allow]
          transitions.include? name
        end

      end
 
    end
  end
end