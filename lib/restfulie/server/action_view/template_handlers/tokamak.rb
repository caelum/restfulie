module Restfulie
  module Server
    module ActionView
      module TemplateHandlers
        class Tokamak < ::ActionView::TemplateHandler
          include ::ActionView::TemplateHandlers::Compilable
            
          def compile(template)
            "@restfulie_type_helpers = Medie.registry.for(self.response.content_type).helper; " +
            "extend @restfulie_type_helpers; " +
            "extend Restfulie::Server::ActionView::Helpers; " +
            "code_block = lambda { #{template.source} };" + 
            "builder = code_block.call; " +
            "self.response.headers['Link'] = Tokamak::Common.extract_link_header(builder.links) if builder.respond_to?(:links); " +
            "builder.to_s"
          end
        end
      end
    end
  end
end