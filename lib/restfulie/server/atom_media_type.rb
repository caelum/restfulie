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
    last_modified = updated_at
    '<?xml version="1.0"?>
    <feed xmlns="http://www.w3.org/2005/Atom">
      <id>urn:uuid:d0b4f914-30e9-418c-8628-7d9b7815060f</id>
      <title type="text">Hotels list</title>
      <updated>2009-07-01T12:05:00Z</updated>
      <generator uri="http://caelumtravel.com">Hotels Service</generator>
      <link rel="self" href="http://caelumtravel.com/hotels"/>'
      +
      to_xml
      + '</feed>'
  end
  def updated_at
    last = Time.now
    each do |item|
      last = item.updated_at if item.respond_to? :updated_at && item.updated_at > last
    end
    last
  end
end
