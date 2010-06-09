module Restfulie
  module Server
    module ActionView
      module TemplateHandlers
        class Tokamak < ::ActionView::TemplateHandler
          include ::ActionView::TemplateHandlers::Compilable
            
          def compile(template)
            "@restfulie_type_helpers = Restfulie::Client::HTTP::RequestMarshaller.content_type_for(self.response.content_type).helper; " +
            "extend @restfulie_type_helpers; " +
            "extend Restfulie::Server::ActionView::Helpers; " +
            "code_block = lambda { #{template.source} };" + 
            "builder = code_block.call; " +
            "self.response.headers['Link'] = Restfulie::Common::Representation::Links.extract_link_header(builder.links); " +
            "builder.to_s"
          end
        end
      end
    end
  end
end