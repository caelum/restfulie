class Restfulie::Server::ActionController::Base < ::ApplicationController
  unloadable
        
  protected

    # If your controller inherits from ActionController::Restfulie::Base,
    # it will have an :atom option, very similar to render :xml
    def render(options = nil, extra_options = {}, &block)
      if atom = options[:atom]
        response.content_type ||= Mime::ATOM
        render_for_text(atom.respond_to?(:to_atom) ? atom.to_atom.to_xml : atom.to_xml, options[:status])
      else
        super
      end
    end
       
end

