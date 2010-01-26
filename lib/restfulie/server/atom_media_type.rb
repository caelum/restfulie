#
#  Copyright (c) 2009 Caelum - www.caelum.com.br/opensource
#  All rights reserved.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); 
#  you may not use this file except in compliance with the License. 
#  You may obtain a copy of the License at 
#  
#   http://www.apache.org/licenses/LICENSE-2.0 
#  
#  Unless required by applicable law or agreed to in writing, software 
#  distributed under the License is distributed on an "AS IS" BASIS, 
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
#  See the License for the specific language governing permissions and 
#  limitations under the License. 
#

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