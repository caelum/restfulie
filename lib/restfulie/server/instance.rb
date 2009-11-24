module Restfulie
  module Server
    module Instance

      # Returns an array with extra possible transitions.
      # Those transitions will be concatenated with any extra transitions provided by your resource through
      # the use of state and transition definitions.
      # For every transition its name is the only mandatory field:
      # options = {}
      # [:show, options] # will generate a link to your controller's show action
      #
      # The options can be used to override restfulie's conventions:
      # options[:rel] = "refresh" # will create a rel named refresh
      # options[:action] = "destroy" # will link to the destroy method
      # options[:controller] = another controller # will use another controller's action
      #
      # Any extra options will be passed to the target controller url_for method in order to retrieve
      # the transition's uri.
      def following_transitions
        []
      end

    end
  end
end