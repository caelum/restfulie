module Restfulie
  module Server
    module Controller
      class Base < ::ApplicationController
        unloadable  
        
      protected
      
        def render(options = nil, extra_options = {}, &block)
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
  
  module Controller
    Base = Restfulie::Server::Controller::Base
  end
end