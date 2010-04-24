module Restfulie::Server::ActionView::TemplateHandlers
  
  class Tokamak < ActionView::TemplateHandler
    include ActionView::TemplateHandlers::Compilable
      
    def compile(template)
      "extend Restfulie::Common::Builder::Helpers; " +
      "extend Restfulie::Server::ActionView::Helpers; " +
      "code_block = lambda { #{template.source} };" + 
      "builder = code_block.call; " +
      # "builder.to_atom "
      "builder.send \"to_\#{self.response.content_type}\" "
    end
  end
end
