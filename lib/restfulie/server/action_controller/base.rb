module Restfulie
  module Server
    module ActionController

      class UnsupportedMediaType < ActionControllerError; end #:nodoc:
      class BadRequest < ActionControllerError; end #:nodoc:

      class Base < ::ApplicationController
        #unloadable

        self.rescue_responses['Restfulie::Server::ActionController::UnsupportedMediaType'] = :unsupported_media_type
        self.rescue_responses['Restfulie::Server::ActionController::BadRequest'] = :bad_request
        
        # Sets a default responder for this controller. 
        # Needs to require responder_legacy.rb
        self.responder = Restfulie::Server::ActionController::RestfulResponder
        
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
        
        # TODO remove this! Parses the request content and content type through object unmarshalling.
        def parse_request_content
          Restfulie::Server::HTTP::Unmarshal.new.unmarshal(request)
        end

      end
    end
  end
end
