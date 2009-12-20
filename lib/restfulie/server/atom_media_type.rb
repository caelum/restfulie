module Restfulie
  
  module Server
    
    class AtomMediaType < Restfulie::MediaType::Type
      def initialize(name, type)
        super(name, type)
      end
      def execute_for(controller, resource, options, render_options)
        response = ["atom"].include?(format_name) ? resource.send(:"to_#{format_name}", options) : resource
        render(controller, response, render_options)
      end
    end
    
  end
  
  Restfulie::MediaType.register(Restfulie::MediaType.rendering_type('application/atom+xml', Server::AtomMediaType))
  
end

class Array
  extend Restfulie::MediaTypeControl
  media_type "application/atom+xml"
  def to_atom
    puts "atom content from array here"
  end
end
