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
  
  def to_atom(options = {})
    AtomFeed.new(self).title(options[:title]).to_atom
  end
  
end

class AtomFeed
  def initialize(feed)
    @feed = feed
    @title = "feed"
  end
  
  def title(title)
    @title = title
    self
  end
  
  def to_atom(controller)
    last_modified = updated_at
    xml = items_to_atom_xml
    '<?xml version="1.0"?>
      <feed xmlns="http://www.w3.org/2005/Atom">
        <id>urn:uuid:d0b4f914-30e9-418c-8628-7d9b7815060f</id>' +
      "\n        <title type=\"text\">#{@title}</title>
        <updated>"  + last_modified.strftime("%Y-%m-%dT%H:%M:%S-08:00") + """</updated>
        <generator uri=\"http://caelumtravel.com\">Hotels Service</generator>
        #{self_link(controller)}
        #{xml}
      </feed>"""
  end
  
  def self_link(controller)
    uri = controller.url_for({})
    "<link rel=\"self\" href=\"#{uri}\"/>"
  end
  
  def updated_at
    last = nil
    @feed.each do |item|
      last = item.updated_at if item.respond_to?(:updated_at) && (last.nil? || item.updated_at > last)
    end
    last || Time.now
  end
  
  def items_to_atom_xml
    ""
  end

end