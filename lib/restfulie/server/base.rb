module Restfulie
  module Server
    module Base
    
      # returns the definition for the transaction
      def existing_transition(name)
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
      def transition(name = nil, options = {}, result = nil, &body)
        return TransitionBuilder.new(self) if name.nil?
      
        transition = Restfulie::Server::Transition.new(name, options, result, body)
        transitions[name] = transition

        define_execution_method(self, name, result)
        define_can_method(self, name)
      end
      
      class TransitionBuilder
        def initialize(type)
          @type = type
        end
        def method_missing(name, *args)
          @transition = Restfulie::Server::Transition.new(name)
          @type.transitions[name] = @transition
          @type.define_can_method(@type, name)
          self
        end
        
        def at(options)
          @transition.options = options
        end
        
        def results_in(result)
          @transition.result = result
        end
        
      end
 
      def define_execution_method(type, name, result) 
        type.send(:define_method, name) do |*args|
          self.status = result.to_s unless result.nil?
        end unless type.respond_to?(name)
      end
 
      def define_can_method(type, name) 
        type.send(:define_method, "can_#{name}?") do
          transitions = self.available_transitions[:allow]
          transitions.include? name
        end unless type.respond_to?("can_#{name}?")
      end
 
    end
  end
end