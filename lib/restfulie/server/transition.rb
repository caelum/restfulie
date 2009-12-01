module Restfulie
  
  module Server

    # represents a transition on the server side
    class Transition
      attr_reader :body, :name
      attr_writer :options
      attr_accessor :result
      def initialize(name, options = {}, result = nil, body = nil)
        @name = name
        @options = options
        @result = result
        @body = body
      end
      def action
        @options || {}
      end
      
      # executes this transition in a resource
      def execute_at(target_object)
        target_object.status = result.to_s unless result.nil?
      end
    
      # adds a link to this transition's uri on a xml writer
      def add_link_to(xml, model, options)
        specific_action = action.dup
        specific_action = @body.call(model) if @body

        # if you use the class level DSL, you will need to add a lambda for instance level accessors:
        #   transition :show, {:action => :show, :foo_id => lambda { |model| model.id }}
        # but you can replace it for a symbol and defer the model call
        #   transition :show, {:action => :show, :foo_id => :id}
        specific_action = specific_action.inject({}) do |actions, pair|
          if pair.last.is_a?( Symbol ) && model.respond_to?(pair.last)
            actions.merge!( pair.first => model.send(pair.last) )
          else
            actions.merge!( pair.first => pair.last )
          end
        end

        rel = specific_action[:rel] || @name
        specific_action[:rel] = nil

        specific_action[:action] ||= @name
        uri = options[:controller].url_for(specific_action)
      
        if options[:use_name_based_link]
          xml.tag!(rel, uri)
        else
          xml.tag!('atom:link', 'xmlns:atom' => 'http://www.w3.org/2005/Atom', :rel => rel, :href => uri)
        end
      end
      
    end
  end

end
