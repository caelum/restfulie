module Restfulie
  module Server
    module ActionController

      module Base

        def self.included(base)
          # Sets a default responder for this controller. 
          # Needs to require responder_legacy.rb
          base.responder = Restfulie::Server::ActionController::RestfulResponder
          base.extend(Restfulie::Server::ActionController::Base::ClassMethods)
          # Atom representation is added by default
          ParamsParser.register('application/atom+xml', Restfulie::Common::Representation::Atom)
        end

        module ClassMethods
          def call(env)
            if include_restfulie?
              return env["action_controller.restfulie.response"] if env.has_key?("action_controller.restfulie.response")
            end
            super
          end

          def include_restfulie?
            defined?(Restfulie::Server::ActionController::Base) && controller_class_name.constantize.include?(Restfulie::Server::ActionController::Base)
          end
        end

      protected
      
        # If your controller inherits from Restfulie::Server::Controller::Base,
        # it will have an :atom option, very similar to render :xml
        def render(options = {}, extra_options = {}, &block)
          if atom = options[:atom]
            response.content_type ||= Mime::ATOM
            render_for_text(atom.respond_to?(:to_atom) ? atom.to_atom.to_xml : atom.to_xml, options[:status])
          else
            super
          end
        end
        
      end
    end
  end
end
