module Restfulie
  module Server
    module ActionView
      module TemplateHandlers #:nodoc:
        autoload :Tokamak, 'restfulie/server/action_view/template_handlers/tokamak'
      
        def self.activate!
          if defined? ::ActionView::Template and 
            ::ActionView::Template.respond_to?(:register_template_handler)
              ::ActionView::Template
          else
            ::ActionView::Base
          end.register_template_handler(:tokamak, 
                Restfulie::Server::ActionView::TemplateHandlers::Tokamak)
      
          if defined? ::ActionController::Base
            ::ActionController::Base.exempt_from_layout :tokamak 
          end    
        end
      end
    end
  end
end
