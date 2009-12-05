module Restfulie
  module Server
    module Instance

      # returns a list of available transitions for this objects state
      # TODO rename because it should never be used by the client...
      def available_transitions
        status_available = respond_to?(:status) && status!=nil
        return {:allow => []} unless status_available
        self.class.states[self.status.to_sym] || {:allow => []}
      end
      
      # returns a list containing all available transitions for this object's state
      def all_following_transitions
        all = [] + available_transitions[:allow]
        following_transitions.each do |t|
          t = Restfulie::Server::Transition.new(t[0], t[1], t[2], nil) if t.kind_of? Array
          all << t
        end
        all
      end

      # checks if its possible to execute such transition and, if it is, executes it
      def move_to(name)
        raise "Current state #{status} is invalid in order to execute #{name}. It must be one of #{transitions}" unless available_transitions[:allow].include? name
        self.class.transitions[name].execute_at self
      end

    end
  end
end