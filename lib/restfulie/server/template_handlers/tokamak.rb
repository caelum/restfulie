module Restfulie::Server::TemplateHandlers
  
  class Tokamak < ActionView::TemplateHandler
    include ActionView::TemplateHandlers::Compilable
      
    def compile(template)
      "_set_controller_content_type(Mime::ATOM); " +
      template.source
    end
  end
end

if defined? ActionView::Template and ActionView::Template.respond_to? :register_template_handler
  ActionView::Template
else
  ActionView::Base
end.register_template_handler(:tokamak, ::Restfulie::Server::TemplateHandlers::Tokamak)