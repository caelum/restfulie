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
  
  def to_atom(options = {}, &block)
    AtomFeed.new(self).title(options[:title]).to_atom(options[:controller], block)
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
  
  def to_atom(controller, block = nil)
    last_modified = updated_at
    id = id_for(controller)
    xml = items_to_atom_xml(controller, block)
    """<?xml version=\"1.0\"?>
      <feed xmlns=\"http://www.w3.org/2005/Atom\">
        <id>#{id}</id>
        <title type=\"text\">#{@title}</title>
        <updated>"""  + last_modified.strftime("%Y-%m-%dT%H:%M:%S-08:00") + """</updated>
        <author><name>#{@title}</name></author>
        #{self_link(controller)}
        #{xml}
      </feed>"""
  end
  
  def id_for(controller)
    @id || controller.url_for({})
  end
  
  def id(*id)
    @id = id
    self
  end
  
  def self_link(controller, what = {})
    uri = controller.url_for(what)
    "<link rel=\"self\" href=\"#{uri}\"/>"
  end
  
  def updated_at
    @feed.updated_at
  end
  
  def items_to_atom_xml(controller, serializer = nil)
    xml = ""
    @feed.each do |item|
      uri = controller.url_for(item)
      media_type = item.class.respond_to?(:media_type_representations) ? item.class.media_type_representations[0] : 'application/xml'
      item_xml = serializer.nil? ? item.to_xml(:controller => controller, :skip_instruct => true) : serializer.call(item)
      xml += """          <entry>
            <id>#{uri}</id>
            <title type=\"text\">#{item.class.name}</title>
            <updated>#{modification_for(item).strftime("%Y-%m-%dT%H:%M:%S-08:00")}</updated>
            #{self_link(controller, item)}
            <content type=\"#{media_type}\">
              #{item_xml}
            </content>
          </entry>\n"""
    end
    xml
  end
  
  def modification_for(item)
    item.respond_to?(:updated_at) ? item.updated_at : Time.now
  end

end