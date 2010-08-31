module Restfulie
  module Server
    module ActionView
      module TemplateHandlers #:nodoc:
        autoload :Tokamak, 'restfulie/server/action_view/template_handlers/tokamak'
        
        def self.template_registry
          if defined? ::ActionView::Template and 
            ::ActionView::Template.respond_to?(:register_template_handler)
              ::ActionView::Template
          else
            ::ActionView::Base
          end
        end
        
        # It is needed to explicitly call 'activate!' to install the Tokamak
        # template handler
        def self.activate!
          template_registry.register_template_handler(:tokamak, 
                Restfulie::Server::ActionView::TemplateHandlers::Tokamak)
      
          # TODO unsure if it can be removed. check feedback prior to 1.0.0
          # if defined?(::ActionController::Base) && ::ActionController::Base.respond_to?(:exempt_from_layout)
            # ::ActionController::Base.exempt_from_layout :tokamak 
          # end    
        end
      end
    end
  end
end
