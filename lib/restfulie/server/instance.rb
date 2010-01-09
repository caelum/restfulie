module Restfulie
  module Server
    module Instance

      # checks whether this resource can execute a transition or has such a relation
      def can?(what)
        what = what.to_sym if what.kind_of? String
        all_following_transitions.each do |t|
          return true if t.name == what
        end
        false
      end

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
      
      # gets all the links for each transition
      def links(controller)
        links = []
        unless controller.nil?
          all_following_transitions.each do |transition|
            rel, uri = link_for(transition, controller)
            links << {:rel => rel, :uri => uri}
          end
        end
        links
      end

      private
      # gets a link for this transition
      def link_for(transition, controller) 
        transition = self.class.existing_transition(transition.to_sym) unless transition.kind_of? Restfulie::Server::Transition
        transition.link_for(self, controller)
      end

    end
  end
end