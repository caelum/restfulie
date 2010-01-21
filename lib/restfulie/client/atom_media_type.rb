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
  
  # TODO break media type registering for DECODING and ENCODING appart, so we can have two files
  module Server
    
    # a decoder from atom an feed
    class AtomMediaType < Restfulie::MediaType::Type
      
      def self.from_xml(xml)
        hash = Hash.from_xml xml
        AtomFeedDecoded.new(hash.values.first)
      end
      
    end
    
    # an atom feed
    class AtomFeedDecoded < Hashi::CustomHash
      
      def initialize(hash)
        super(hash)
      end
  
      # retrieves the nth element from an atom feed
      def [](position)
        
        hash = entry[position].content.internal_hash
        hash = hash.dup
        hash.delete("type")
        result = Restfulie::MediaType::DefaultMediaTypeDecoder.from_hash(hash)
        
        add_links_to(result, entry[position]) if entry[position].respond_to?(:link)
        result
        
      end
      
      private
      
      def add_links_to(result, entry)
        links = entry.link.internal_hash
        links = [links] if links.kind_of? Hash
        self_definition = self_from(links)
        links << {:rel => "destroy", :method => "delete", :href => self_definition["href"]} unless self_definition.nil?
        result.add_transitions(links)
      end
      
      def self_from(links)
        links.find do |link|
          link["rel"] == "self" || link[:rel] == "self"
        end
      end
      
    end
    
  end
  
  Restfulie::MediaType.register(Restfulie::MediaType.rendering_type('application/atom+xml', Server::AtomMediaType))
  
end
