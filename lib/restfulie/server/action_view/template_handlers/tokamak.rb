module Restfulie::Server::ActionView::TemplateHandlers
  
  class Tokamak < ActionView::TemplateHandler
    include ActionView::TemplateHandlers::Compilable
      
    # TODO: Implement error for code not return builder
    def compile(template)
      "@restfulie_type_helpers = \"Restfulie::Common::Converter::\#{Mime::Type.lookup(request.accept).to_sym.to_s.titleize}::Helpers\".constantize;" +
      "extend @restfulie_type_helpers; " +
      "extend Restfulie::Server::ActionView::Helpers; " +
      "code_block = lambda { #{template.source} };" + 
      "builder = code_block.call; " +
      "builder.to_s"
    end
  end
end
