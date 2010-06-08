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
            "links = builder.links.collect do |link|; " +
            '"<#{link.href}>; rel=#{link.rel}"; ' +
            "end; " +
            "self.response.headers['Link'] = links.join(', '); " +
            "builder.to_s"
          end
        end
      end
    end
  end
end