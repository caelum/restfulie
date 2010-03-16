module Restfulie::Server::TemplateHandlers
  
  class Tokamak < ActionView::TemplateHandler
    include ActionView::TemplateHandlers::Compilable
      
    # TODO: Implement error for code not return builder
    def compile(template)
      "extend Restfulie::Common::Builder::Helpers; " +
      "code_block = lambda { #{template.source} };" + 
      "builder = code_block.call; " +
      "builder.to_atom "
    end
  end
end
